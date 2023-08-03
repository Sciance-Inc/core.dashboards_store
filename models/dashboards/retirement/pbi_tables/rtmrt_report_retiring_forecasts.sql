{# 
    Compute the running number of forecasted retiring employees and combine the forecast with the past values
#}


WITH observed AS (
    SELECT 
        src.job_group_category
        , CONVERT(DATE, CONCAT(src.school_year, '-09-30'), 102) AS school_year
        , COUNT(*) AS observed_retiring_employes
        , NULL AS forecast_retiring_employees
        , NULL AS running_n_retiring_employees
        , 0 AS is_forecast
    FROM 
    ( 
        SELECT
            CASE 
                WHEN MONTH(src.retirement_date) < 7 THEN YEAR(src.retirement_date) - 1 
                ELSE YEAR(src.retirement_date)
            END AS school_year
            , job.job_group_category
        FROM {{ ref('fact_retirement') }} As src
        LEFT JOIN {{ ref('dim_mapper_job_group') }} AS job ON src.corp_empl = job.job_group -- Add the job group category here as I want to aggreagte by job group categories and not by job group.
    ) AS src
    WHERE src.school_year >= {{ store.get_current_year() }} - 10
    GROUP BY 
        src.job_group_category
        , src.school_year
)


SELECT 
    school_year
    , job_group_category
    , NULL AS observed_retiring_employes
    , n_retiring_employees AS forecast_retiring_employees
    , SUM(n_retiring_employees) OVER (PARTITION BY job_group_category ORDER BY school_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_forecast_retiring_employees
    , 1 AS is_forecast
FROM {{ ref('fact_retirement_forecasts') }} 
UNION ALL 
SELECT 
    school_year
    , job_group_category
    , observed_retiring_employes
    , forecast_retiring_employees
    , running_n_retiring_employees
    , is_forecast
FROM observed
