{#
    Compute the distributions of the sequences length and the distribution of the number of sequences per length.
#}

{{ config(alias='report_absences_distributions') }}

-- Agregated absences at a student X school X year  X sequence length level
WITH absences_aggregated AS (
    SELECT 
        fiche
        , eco
        , school_year
        , absences_sequence_length
        , COUNT(*) AS n_absences
        , MAX(absences_sequence_length) OVER (PARTITION BY fiche, eco, school_year) AS max_sequence_length
    FROM {{ ref('fact_absences_sequence') }}
    WHERE school_year > {{ store.get_current_year() - 10 }}
    GROUP BY
        fiche
        , eco
        , school_year
        , absences_sequence_length

-- Get rid of the students dimension : only keep the most up to date school for each student
-- I can't compute the cumulated distributions with a table of such granularity.
), aggregated AS (
    SELECT
        spi.population 
        , src.eco
        , src.school_year
        , src.absences_sequence_length
        , src.n_absences
        , COUNT(src.fiche) AS n_students
        , COUNT(CASE WHEN src.absences_sequence_length = src.max_sequence_length THEN src.fiche END) AS n_students_with_max_sequence_length
    FROM absences_aggregated AS src
    INNER JOIN {{ ref('spine') }} AS spi
    ON
        src.school_year = spi.annee AND 
        src.fiche = spi.fiche AND 
        src.eco = spi.eco AND 
        spi.seqid = 1
    GROUP BY 
        spi.population
        , src.eco
        , src.school_year
        , src.absences_sequence_length
        , src.n_absences

)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['eco', 'school_year', 'population']) }} AS filter_key
    , absences_sequence_length
    , n_absences
    , n_students
    , n_students_with_max_sequence_length
FROM aggregated