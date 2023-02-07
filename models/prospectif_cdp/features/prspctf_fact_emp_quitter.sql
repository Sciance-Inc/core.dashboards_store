{{ config(alias='fact_emp_quitter') }}

WITH src AS (
    SELECT
        *
    FROM {{ ref('i_pai_dos') }}
    WHERE date_dern_jr_trav is not null
    AND etat in ('C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08', 'C09', 'C10', 'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C25', 'C27', 'C31', 'C32', 'C66', 'C99')
)

SELECT  count(matr) as nombre_emp_quitter
      , corp_empl
      , annee_budgetaire
FROM src
GROUP BY corp_empl, annee_budgetaire

