{# 
    Compute the running number of forecasted retiring employees and combine the forecast with the past values
#}
with
    observed as (
        select
            src.job_group_category,
            convert(date, concat(src.school_year, '-09-30'), 102) as school_year,
            count(*) as observed_retiring_employes,
            null as forecast_retiring_employees,
            null as running_n_retiring_employees,
            0 as is_forecast
        from
            (
                select
                    case
                        when month(src.retirement_date) < 7
                        then year(src.retirement_date) - 1
                        else year(src.retirement_date)
                    end as school_year,
                    job.job_group_category
                from {{ ref("fact_retirement") }} as src
                left join
                    {{ ref("dim_mapper_job_group") }} as job
                    on src.corp_empl = job.job_group  -- Add the job group category here as I want to aggreagte by job group categories and not by job group.
            ) as src
        where src.school_year >= {{ store.get_current_year() }} - 10
        group by src.job_group_category, src.school_year
    )

select
    school_year,
    job_group_category,
    null as observed_retiring_employes,
    n_retiring_employees as forecast_retiring_employees,
    sum(n_retiring_employees) over (
        partition by job_group_category
        order by school_year
        rows between unbounded preceding and current row
    ) as running_forecast_retiring_employees,
    1 as is_forecast
from {{ ref("fact_retirement_forecasts") }}
union all
select
    school_year,
    job_group_category,
    observed_retiring_employes,
    forecast_retiring_employees,
    running_n_retiring_employees,
    is_forecast
from observed
