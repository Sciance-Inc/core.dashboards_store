{{ config(alias="report_survival_curve") }}

select age, instantaneous_death_rate, survival_rate
from {{ ref("stg_retirement_survival_curve") }}
