{#
    Compute the number of retirees and the age they retired at per school year, job group, workplace, engagement status, and employment status.

    Because of the double-granularity difference (age and school_year) with the rtmrt_report_active_employees_age table, a surrogate key is generated to allow the user to filter on both dimensions at the same time
#}

{{ config(
    alias='report_retirement_age'
) }}

-- Add some metadata : the school year and the job group
WITH source AS (
    SELECT
        CASE 
            WHEN MONTH(src.retirement_date) < 7 THEN YEAR(src.retirement_date) - 1 
            ELSE YEAR(src.retirement_date)
        END AS school_year,
        src.matr AS matricule,
        dos.sexe,
        COALESCE(job.job_group_category, 'Inconnu') AS job_group_category,
        COALESCE(src.lieu_trav, 'Inconnu') AS lieu_trav,
        COALESCE(src.stat_eng, 'Inconnu') AS stat_eng,
        COALESCE(src.etat, 'Inconnu') AS etat,
        src.retirement_age
    FROM {{ ref('fact_retirement') }} As src
    LEFT JOIN {{ ref('dim_mapper_job_group') }} AS job ON src.corp_empl = job.job_group -- Add the job group category here as I want to aggreagte by job group categories and not by job group.
    LEFT JOIN {{ ref('i_pai_dos') }} AS dos ON src.matr = dos.matr

-- Compute some aggregated statistics
), aggregated AS (
    SELECT 
        sexe,
        etat,
        school_year,
        job_group_category,
        lieu_trav,
        stat_eng,
        retirement_age,
        COUNT(*) AS n_retirees
    FROM source
    WHERE school_year >= {{ tbe.get_current_year() }} - 10
    GROUP BY 
        sexe,
        etat,
        school_year,
        job_group_category,
        lieu_trav,
        stat_eng,
        retirement_age
) 

-- Flag the current year
SELECT 
    sexe,
    etat,
    job_group_category,
    lieu_trav,
    stat_eng,
    CONVERT(DATE, CONCAT(school_year, '-09-30'), 102) AS school_year,
    CASE WHEN {{ tbe.get_current_year() }} = school_year THEN 1 ELSE 0 END AS is_current_year,
    retirement_age, 
    n_retirees,
    {{ dbt_utils.generate_surrogate_key(['sexe', 'job_group_category', 'lieu_trav', 'stat_eng', 'etat']) }} AS filter_key
FROM aggregated



