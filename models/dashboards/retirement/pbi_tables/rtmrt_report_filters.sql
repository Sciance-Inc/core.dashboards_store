{#
    Compute the full set of slicers for the two reports tables.

    Because of the double-granularity difference (age and school_year) between the rtmrt_report_retirement_age table and the trmrt_report_active_employees_age table, I can't properly combine the two report tables.
    Since powerbi doesn't support many-to-many relations, the filters have to be implemented in a separated table.
    
    That's gross.
#}

{{ config(
    alias='report_filters'
) }}


with one_for_all AS (
    SELECT 
        src.sexe,
        src.lieu_trav,
        src.stat_eng,
        src.etat,
        src.job_group_category,
        src.filter_key,
        MAX(src.filter_source) AS filter_source
    FROM (
        SELECT 
            sexe,
            lieu_trav,
            stat_eng,
            etat,
            job_group_category,
            'active' AS filter_source,
            filter_key
        FROM {{ ref('rtmrt_report_active_employees_age') }}
        UNION ALL
        SELECT 
            sexe,
            lieu_trav,
            stat_eng,
            etat,
            job_group_category,
            'retirement' AS filter_source,
            filter_key
        FROM {{ ref('rtrmt_report_retirement_age') }}
    ) AS src
    GROUP BY 
        src.sexe,
        src.lieu_trav,
        src.stat_eng,
        src.etat,
        src.job_group_category,
        src.filter_key

) 

-- Join the friendly name
SELECT 
    src.sexe,
    empl.employment_status_name,
    eng.engagement_status_name,
    work.workplace_name,
    src.job_group_category,
    src.filter_key,
    src.filter_source
FROM one_for_all AS src
LEFT JOIN {{ ref('dim_mapper_employment_status') }} AS empl
ON src.etat = empl.employment_status
LEFT JOIN {{ ref('dim_mapper_engagement_status') }} AS eng
ON src.stat_eng = eng.engagement_status
LEFT JOIN {{ ref('dim_mapper_workplace') }} AS work
ON src.lieu_trav = work.workplace


