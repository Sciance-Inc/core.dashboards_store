{# 
    Compute a `concentration` of absences sequences for differents brackets of absences.

    The script estimate the lorenz curve for the absences : how many absences are `trusted` by the most absents students ?
    This table can serve as an input for computing the Gini coefficient of such concentrations estimation.

    The aggregatiopn bracket can be configured through the overriding of the repartition_brackets.

#} 

{{ config(alias='report_absences_concentration') }}

-- Agregated absences at a student X school X year X absence length
-- AND Map each absences_sequence_length to a bucket the analysis is splitted by
WITH absences_aggregated AS (
    SELECT 
        src.fiche
        , spi.population
        , src.eco
        , src.school_year
        , bra.name AS bracket_name
        , COUNT(src.absence_sequence_id) AS n_absences
    FROM {{ ref('fact_absences_sequence') }} AS src
    INNER JOIN {{ ref('spine') }} AS spi
    ON 
        src.fiche = spi.fiche AND 
        src.eco = spi.eco AND 
        src.school_year = spi.annee AND
        spi.seqid = 1
    INNER JOIN {{ ref('repartition_brackets') }} AS bra
    ON 
        src.absences_sequence_length >= bra.lower_bound AND 
        src.absences_sequence_length < bra.upper_bound
    WHERE school_year > {{ store.get_current_year() - 10 }}
    GROUP BY
        src.fiche
        , spi.population
        , src.eco
        , src.school_year
        , bra.name

), running AS (
    SELECT 
        eco
        , population
        , school_year
        , bracket_name
        , 1.0 * COUNT(fiche) OVER (PARTITION BY population, eco, school_year, bracket_name ORDER BY n_absences DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_count_students
        , 1.0 * SUM(n_absences) OVER (PARTITION BY population, eco, school_year, bracket_name ORDER BY n_absences DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum_absences
    FROM absences_aggregated

-- Normalize lorenz values
), normalized AS (
    SELECT
        eco
        , population
        , school_year
        , bracket_name
        , running_count_students / MAX(running_count_students) OVER (PARTITION BY population, eco, school_year, bracket_name) AS percentage_of_students
        , running_sum_absences / MAX(running_sum_absences) OVER (PARTITION BY population, eco, school_year, bracket_name) AS percentage_of_absences
        , running_count_students AS weight -- To ponderate the comnbinated graphs
    FROM  running

-- To reduce the number of points, I only keep the 10th, 20th, 30th, 40th, 50th, 60th, 70th, 80th, 90th and 100th percentiles
-- Fetch the target percentile
), perc_target AS (
    SELECT (1.0 * seq_value) / 10 AS perc_target 
    FROM {{ ref('int_sequence_0_to_1000') }}
    WHERE seq_value BETWEEN 1 AND 10

-- Cross join the percentile and compute the distance between observed values and targets percentiles
), distance AS (
    SELECT 
        dst.population
        , dst.eco
        , dst.school_year
        , dst.bracket_name
        , dst.percentage_of_absences
        , dst.distance
        , dst.perc_target
        , dst.weight
        , ROW_NUMBER() OVER (PARTITION BY dst.population, dst.eco, dst.school_year, dst.bracket_name, dst.perc_target ORDER BY distance) AS rank
    FROM (
        SELECT 
            obs.population
            , obs.eco
            , obs.school_year
            , obs.bracket_name
            , obs.percentage_of_students
            , obs.percentage_of_absences
            , trg.perc_target
            , ABS(trg.perc_target - obs.percentage_of_students) AS distance
            , obs.weight
        FROM normalized AS obs
        INNER JOIN perc_target AS trg -- Instead of a cross join, I use an inner join to avoid the cartesian product and reduce the needs for distance computation
        ON obs.percentage_of_students BETWEEN trg.perc_target - 0.05 AND trg.perc_target + 0.05
    ) AS dst
)


SELECT  
    {{ dbt_utils.generate_surrogate_key(['eco', 'school_year', 'population']) }} AS filter_key
    , bracket_name
    , percentage_of_absences
    , perc_target
    , weight
FROM distance
WHERE rank = 1 -- Keep only the closest distance for each target percentile

