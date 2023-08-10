{#
    Compute the sequence of days with at least one periode of absence.
#}

-- Extract all the days a student is expected to be there 
WITH expected_cal AS (
    SELECT 
    	CASE         
            WHEN MONTH(date_evenement) <= 7 THEN YEAR(date_evenement) - 1 
            ELSE YEAR(date_evenement)
        END AS school_year
        , id_eco
        , date_evenement
    FROM {{ ref('i_gpm_t_cal')}} As cal
    WHERE 
        jour_cycle IS NOT NULL AND 
        grille IN ('1', 'A')

-- Add a sequence id : day_id to later identify the break between two sequences of absences
), expected_cal_with_id AS (
    SELECT 
        school_year
        , id_eco
        , date_evenement
        , ROW_NUMBER() OVER (PARTITION BY id_eco, school_year ORDER BY date_evenement) AS day_id
    FROM expected_cal

-- Left join the observed absences on the calendar
), observed AS (
    SELECT 
        exp.school_year
        , exp.id_eco
        , exp.date_evenement
        , exp.day_id
        , abs.fiche
    FROM expected_cal_with_id AS exp
    INNER JOIN {{ ref('stg_absences_per_period')}} AS abs
    ON
        exp.id_eco = abs.id_eco AND 
        exp.date_evenement = abs.date_abs

-- Get the between-sequences-of-absences breaks by checking if the previous day was a day of absence too
), breaks AS (
    SELECT
        school_year
        , id_eco
        , date_evenement
        , day_id
        , CASE 
            WHEN day_id - LAG(day_id) OVER(PARTITION BY school_year, id_eco, fiche ORDER BY day_id) > 1 THEN 1 
            ELSE 0 
        END AS sequence_break
        , fiche
    FROM observed

-- SUM over the break id to get a sequence_id
), sequences AS (
    SELECT
        school_year
        , id_eco
        , date_evenement
        , day_id
        , fiche 
        , SUM(sequence_break) OVER(PARTITION BY school_year, id_eco, fiche ORDER BY day_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS absence_sequence_id
    FROM breaks

), aggregated AS (
-- Create the final table : one row per fiche X school X year X sequence of absences
SELECT 
    school_year
    , fiche
    , id_eco
    , absence_sequence_id
    , MIN(date_evenement) AS absence_start_date
    , MAX(date_evenement) AS absence_end_date
    , MAX(day_id) - MIN(day_id) + 1 AS absences_sequence_length
FROM sequences
GROUP BY 
    school_year
    , fiche
    , id_eco
    , absence_sequence_id

-- Add final dimensions 
)

SELECT 
    src.school_year
    , src.fiche
    , eco.eco
    , src.absence_sequence_id
    , src.absence_start_date
    , src.absence_end_date
    , src.absences_sequence_length
FROM aggregated AS src
LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco 
ON src.id_eco = eco.id_eco
