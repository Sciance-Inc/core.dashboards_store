{{ config(alias='fact_emp_quitter') }}

SELECT
    *
FROM {{ ref('i_pai_dos') }}