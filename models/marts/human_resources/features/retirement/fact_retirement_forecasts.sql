{# 
    This script forecast the number of currently active employes retiring in the next 5 years.
    The forecast is done using the Kaplan-Meier survival curves estimated in the stg_retirement_survival_curve.sql script.

    I first group together active employes by age (called cohorts) then `age` the whole cohort for up to 5 years, I then compute the cohort survival rate by applying the Kaplan-Meier estimator to each cohort x projected-age combination.
    Finaly, retiring employees for each year is then computed by differencing (first-order) the previously obtained number of surviviors for each year with respect to each cohort.

    About the horizon 0 forecast : 
    * Since I'm differentiating the cumulated survival to get the instantaneous survavival, the horizon 0 will act as a kind of a normalization constant and will capture some of the noise from the survival curve partial mis-fitting.
    * The horizon 0 has, from a dashboarding viewpoint, no real meaning and is removed from the final table
 #}


-- Compute the age of the active employes at the start of the year
with age_1_september AS (
    SELECT 
        src.matr
        , src.job_group_category
        , DATEDIFF(YEAR, src.date_nais, crt.current_year) AS age -- Age at september the first of the current year
    FROM (
        SELECT 
            src.matr
            , job.job_group_category
            , dos.date_nais
        FROM {{ ref('fact_active_employes') }} AS src
        LEFT JOIN {{ ref('i_pai_dos') }} AS dos
        ON src.matr = dos.matr
        LEFT JOIN {{ ref('dim_mapper_job_group') }} AS job 
        ON src.corp_empl = job.job_group
        WHERE src.matr NOT IN (SELECT matr FROM {{ ref('fact_retirement') }} ) -- Remove the already retired employes
    ) AS src
    -- Add the current_year date to compute the age at semptember the first of the current scholar year
    CROSS JOIN (
        SELECT CONCAT({{ tbe.get_current_year() }},'-09-01') AS current_year 
    ) AS crt

-- Group together active employes by cohorts
), cohorts AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['age', 'job_group_category']) }} AS cohort_id
        , 0 AS forecast_horizon -- Initialize the forecast horizon to the current year (since the age is computed at the start of the year)
        , age
        , job_group_category
        , COUNT(matr) AS n_employees
    FROM age_1_september
    WHERE age BETWEEN 45 and 70 -- Only keep employes between 45 and 70 years old as the survival curve is only estimated for the age range [50, 70] 
    GROUP BY 
        age
        , job_group_category

-- Age the cohorts for up to 5 years
), aged_cohorts AS (
    SELECT 
        crt.cohort_id
        , crt.age + hrz.horizon AS age
        , crt.forecast_horizon + hrz.horizon AS forecast_horizon
        , crt.job_group_category
        , crt.n_employees
    FROM cohorts AS crt
    CROSS JOIN (SELECT seq_value AS horizon FROM {{ ref('int_sequence_0_to_1000')}} WHERE seq_value BETWEEN 0 AND 5) AS hrz

-- Add the survival rate for each cohort x age
), cumulated AS (
    SELECT 
        src.cohort_id
        , src.forecast_horizon
        , src.job_group_category
        , src.n_employees
        , surv.survival_rate 
        , ROUND(src.n_employees - (src.n_employees * surv.survival_rate), 0) AS n_cumulated_retired
    FROM aged_cohorts AS src
    INNER JOIN {{ ref('stg_retirement_survival_curve') }} AS surv
    ON src.age = surv.age

-- Differentiate the cumulated number of retiring employees with respect to the cohort_ID to the forecast horizon to get the instantenous retiring employees
), differentiated AS ( 
    SELECT 
        cohort_id
        , forecast_horizon
        , job_group_category
        , n_cumulated_retired - LAG(n_cumulated_retired) OVER (PARTITION BY cohort_id ORDER BY forecast_horizon) AS instantaneous_retiring_employees
    FROM cumulated

-- Aggregate the number of retiring employees by school year and job group category (get rid of the age and cohort dimensions as we don't care about the age of the retiring employee)
), aggregated AS (
    SELECT 
        forecast_horizon
        , job_group_category
        , SUM(instantaneous_retiring_employees) AS instantaneous_retiring_employees
    FROM differentiated
    GROUP BY 
        forecast_horizon
        , job_group_category

-- Create a padding table with the year and the job_group_category, to be joined on and handle the 0-retirement case
), padding AS (
    SELECT 
        job.job_group_category,
        CONVERT(DATE, CONCAT({{ tbe.get_current_year() }} + hrz.horizon,'-09-01'), 102) AS school_year,
        hrz.horizon AS forecast_horizon
    FROM (SELECT DISTINCT job_group_category FROM {{ ref('dim_mapper_job_group') }}) AS job
    CROSS JOIN (SELECT seq_value AS horizon FROM {{ ref('int_sequence_0_to_1000')}} WHERE seq_value BETWEEN 1 AND 5) AS hrz

-- Join the padding table to the aggregated table to impute missing values
), imputed AS (
    SELECT 
        pad.school_year
        , pad.job_group_category
        , COALESCE(agg.instantaneous_retiring_employees, 0) AS n_retiring_employees
    FROM padding AS pad
    LEFT JOIN aggregated AS agg
    ON 
        pad.forecast_horizon = agg.forecast_horizon AND 
        pad.job_group_category = agg.job_group_category
)

SELECT 
    school_year
    , job_group_category
    , n_retiring_employees
FROM imputed