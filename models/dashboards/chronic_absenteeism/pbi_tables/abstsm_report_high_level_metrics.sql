{#
    Compute aggregated statistics over time at a school level
#}

{{ config(alias='report_absences_high_level_metrics') }}

-- Agregated absences at a student X school level X year level
WITH absences_aggregated AS (
    SELECT 
        fiche
        , eco
        , school_year
        , COUNT(*) AS n_absences
        , AVG(1.0 * absences_sequence_length) AS avg_absences_sequence_length
        , MAX(absences_sequence_length) AS max_absences_sequence_length
    FROM {{ ref('fact_absences_sequence') }}
    WHERE school_year > {{ store.get_current_year() - 10 }}
    GROUP BY
        fiche
        , eco
        , school_year


-- Left join on the population table to get the 0 absences case, AND the populations at the same time
), padded AS (
    SELECT 
        spi.fiche
        , spi.eco
        , spi.annee AS school_year
        , spi.population
        , abs.n_absences -- Keep the null as the the average schould not took into account the 0 absences
        , abs.avg_absences_sequence_length -- Keep the null as the the average schould not took into account the 0 absences
        , abs.max_absences_sequence_length -- Keep the null as the the average schould not took into account the 0 absences
    FROM {{ ref('spine') }} As spi
    LEFT JOIN absences_aggregated As abs
    ON 
        spi.fiche = abs.fiche AND 
        spi.eco = abs.eco AND
        spi.annee = abs.school_year
    WHERE spi.seqid = 1
 
-- Aggregated absences at a school X year X population
), aggregated AS (
    SELECT 
        eco
        , school_year
        , population
        , AVG(CASE WHEN n_absences IS NOT NULL THEN 1. ELSE 0 END) AS proportion_of_absentees
        -- For student with at least one absence
        , AVG(1. * n_absences) AS avg_n_absences_for_absentees
        , AVG(1. * avg_absences_sequence_length) AS avg_avg_absences_sequence_length_for_absentees
        , AVG(1. * max_absences_sequence_length) AS avg_max_absences_sequence_length_for_absentees
        , COUNT(*) AS n_students
    FROM padded
    GROUP BY 
        eco
        , school_year
        , population

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['eco', 'school_year', 'population']) }} AS filter_key
    ,school_year
    , proportion_of_absentees
    , avg_n_absences_for_absentees
    , avg_avg_absences_sequence_length_for_absentees
    , avg_max_absences_sequence_length_for_absentees
    , n_students
FROM aggregated


