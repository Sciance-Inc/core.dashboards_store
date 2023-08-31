{#
    Select the employees currently working and compute their age at the start of the year

    Because of the double-granularity difference (age and school_year) with the rtmrt_report_retirement_age table, a surrogate key is generated to allow the user to filter on both dimensions at the same time
#}
{{ config(alias="report_employees_age") }}

-- Create the start-of-year date
with
    current_year as (
        select concat({{ store.get_current_year() }}, '-09-01') as current_year

    -- Add the birth date and the sex to the active employes table
    ),
    with_metadata as (
        select
            src.matr,
            src.etat,
            src.lieu_trav,
            src.corp_empl,
            src.stat_eng,
            dos.date_nais,
            dos.sexe
        from {{ ref("fact_active_employes") }} as src
        left join {{ ref("i_pai_dos") }} as dos on src.matr = dos.matr
        where src.matr not in (select matr from {{ ref("fact_retirement") }})  -- Remove the already retired employes

    -- Get the age of the employes currently active
    ),
    active_employees_age as (  -- Get the employees' age at the start of the year
        select
            act.matr,
            act.etat,
            act.lieu_trav,
            act.corp_empl,
            act.stat_eng,
            act.sexe,
            datediff(year, date_nais, current_year) as age  -- Age at september the first of the current year
        from with_metadata as act
        cross join current_year

    -- Adding friendly dimensions
    ),
    friendly_name as (
        select
            src.matr,
            src.sexe,
            src.age,
            coalesce(job.job_group_category, 'Inconnu') as job_group_category,
            coalesce(src.lieu_trav, 'Inconnu') as lieu_trav,
            coalesce(src.stat_eng, 'Inconnu') as stat_eng,
            coalesce(src.etat, 'Inconnu') as etat
        from active_employees_age as src
        left join
            {{ ref("dim_mapper_job_group") }} as job on src.corp_empl = job.job_group

    -- Aggregate the data for the report
    ),
    aggregated as (
        select
            sexe,
            lieu_trav,
            stat_eng,
            etat,
            job_group_category,
            age,
            count(*) as n_employees
        from friendly_name
        group by sexe, lieu_trav, stat_eng, etat, job_group_category, age

    -- Add the filter surrogate key
    )
select
    sexe,
    etat,
    job_group_category,
    lieu_trav,
    stat_eng,
    age,
    n_employees,
    {{
        dbt_utils.generate_surrogate_key(
            [
                "sexe",
                "job_group_category",
                "lieu_trav",
                "stat_eng",
                "etat",
            ]
        )
    }} as filter_key
from aggregated
