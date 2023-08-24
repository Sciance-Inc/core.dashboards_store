{#
    Gather all the filters into one table to allow for between-pages corss filtering.
#}

{{ config(alias='report_absences_filters') }}

-- Select all the schools / year  we have data for with respect to a 10 years time frame.
WITH eco AS (
    SELECT 
        eco
        , annee As school_year
        , school_friendly_name
    FROM {{ ref('dim_mapper_schools') }}
    WHERE annee BETWEEN {{ store.get_current_year() - 10 }} AND {{ store.get_current_year() }}

-- Select all the distinct population we have data for
), popu AS (
    SELECT DISTINCT population
    FROM {{ ref('spine') }}
)

-- Create the composite filter key
SELECT 
    eco.school_friendly_name
    , CONVERT(DATE, CONCAT(eco.school_year, '-09-1'), 102) AS school_year
    , popu.population
    , {{ dbt_utils.generate_surrogate_key(['eco.eco', 'eco.school_year', 'popu.population']) }} AS filter_key
FROM eco AS eco
CROSS JOIN popu AS popu
WHERE 
    eco.eco IS NOT NULL
    AND eco.school_friendly_name IS NOT NULL
    AND popu.population IS NOT NULL AND 
    eco.school_year IS NOT NULL
