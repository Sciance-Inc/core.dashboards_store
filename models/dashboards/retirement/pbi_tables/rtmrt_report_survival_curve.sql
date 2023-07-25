{{ config(
    alias='report_survival_curve'
) }}

SELECT 
    age
    , instantaneous_death_rate
    , survival_rate
FROM {{ ref('stg_retirement_survival_curve') }}