{#
    Select the employees currently working and compute their age at the start of the year

    Because of the double-granularity difference (age and school_year) with the rtmrt_report_retirement_age table, a surrogate key is generated to allow the user to filter on both dimensions at the same time
#}

{{ config(
    alias='report_employees_age'
) }}

-- Create the start-of-year date
WITH current_year AS (
    SELECT CONCAT({{ store.get_current_year() }},'-09-01') AS current_year  


-- Add the birth date and the sex to the active employes table
), with_metadata AS (
    SELECT 
        src.matr,
        src.etat,
        src.lieu_trav,
        src.corp_empl,
        src.stat_eng,
        dos.date_nais,
        dos.sexe
    FROM {{ ref('fact_active_employes') }} AS src
    LEFT JOIN {{ ref('i_pai_dos') }} AS dos
    ON src.matr = dos.matr
    WHERE src.matr NOT IN (SELECT matr FROM {{ ref('fact_retirement') }} ) -- Remove the already retired employes

-- Get the age of the employes currently active
), active_employees_age AS (-- Get the employees' age at the start of the year
    SELECT 
        act.matr,
        act.etat,
        act.lieu_trav,
        act.corp_empl,
        act.stat_eng,
        act.sexe,
        DATEDIFF(YEAR, date_nais, current_year) AS age -- Age at september the first of the current year
    FROM with_metadata AS act
    CROSS JOIN current_year

-- Adding friendly dimensions
), friendly_name AS (
SELECT 
    src.matr,
    src.sexe,
    src.age,
    COALESCE(job.job_group_category, 'Inconnu') AS job_group_category,
    COALESCE(src.lieu_trav, 'Inconnu') AS lieu_trav,
    COALESCE(src.stat_eng, 'Inconnu') AS stat_eng,
    COALESCE(src.etat, 'Inconnu') AS etat
FROM active_employees_age AS src
LEFT JOIN {{ ref('dim_mapper_job_group') }} AS job ON src.corp_empl = job.job_group

-- Aggregate the data for the report
), aggregated AS (
    SELECT 
        sexe,
        lieu_trav,
        stat_eng,
        etat,
        job_group_category,
        age,
        COUNT(*) AS n_employees
    FROM friendly_name
    GROUP BY 
        sexe,
        lieu_trav,
        stat_eng,
        etat,
        job_group_category,
        age

-- Add the filter surrogate key
) 
SELECT
    sexe,
    etat,
    job_group_category,
    lieu_trav,
    stat_eng,
    age,
    n_employees,
        {{ dbt_utils.generate_surrogate_key(['sexe', 'job_group_category', 'lieu_trav', 'stat_eng', 'etat',]) }} AS filter_key
FROM aggregated 

