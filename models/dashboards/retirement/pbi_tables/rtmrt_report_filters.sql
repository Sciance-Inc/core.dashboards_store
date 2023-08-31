{#
    Compute the full set of slicers for the two reports tables.

    Because of the double-granularity difference (age and school_year) between the rtmrt_report_retirement_age table and the trmrt_report_active_employees_age table, I can't properly combine the two report tables.
    Since powerbi doesn't support many-to-many relations, the filters have to be implemented in a separated table.
    
    That's gross.
#}
{{ config(alias="report_filters") }}


with
    one_for_all as (
        select
            src.sexe,
            src.lieu_trav,
            src.stat_eng,
            src.etat,
            src.job_group_category,
            src.filter_key,
            max(src.filter_source) as filter_source
        from
            (
                select
                    sexe,
                    lieu_trav,
                    stat_eng,
                    etat,
                    job_group_category,
                    'active' as filter_source,
                    filter_key
                from {{ ref("rtmrt_report_active_employees_age") }}
                union all
                select
                    sexe,
                    lieu_trav,
                    stat_eng,
                    etat,
                    job_group_category,
                    'retirement' as filter_source,
                    filter_key
                from {{ ref("rtrmt_report_retirement_age") }}
            ) as src
        group by
            src.sexe,
            src.lieu_trav,
            src.stat_eng,
            src.etat,
            src.job_group_category,
            src.filter_key

    )

-- Join the friendly name
select
    src.sexe,
    empl.employment_status_name,
    eng.engagement_status_name,
    work.workplace_name,
    src.job_group_category,
    src.filter_key,
    src.filter_source
from one_for_all as src
left join
    {{ ref("dim_mapper_employment_status") }} as empl
    on src.etat = empl.employment_status
left join
    {{ ref("dim_mapper_engagement_status") }} as eng
    on src.stat_eng = eng.engagement_status
left join {{ ref("dim_mapper_workplace") }} as work on src.lieu_trav = work.workplace
