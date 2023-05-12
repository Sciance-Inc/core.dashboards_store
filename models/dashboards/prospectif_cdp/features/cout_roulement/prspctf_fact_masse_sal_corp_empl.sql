{{ config(alias='fact_masse_sal_corp_emp') }}

WITH src AS (
    SELECT 
        pcb.annee_budgetaire
        , sum(pcb.cumulatif) as cumulatif
        , pcb.corp_empl as corp_empl
    FROM {{ ref('i_pai_cum_budg') }} AS pcb
    WHERE  (code_pmnt_ded like '1%'or code_pmnt_ded like '2%' )                 -- salaire brute (1% et 2%)
    GROUP BY pcb.annee_budgetaire, pcb.corp_empl, pcb.matricule

), mass AS( 

    SELECT 
        LEFT(annee_budgetaire,4) annee_budgetaire
        , corp_empl
        , avg(cumulatif) as sal_moy_corp_emp
        , sum(cumulatif) as masse_salariale_corp_emp
    FROM src
    GROUP BY annee_budgetaire, corp_empl
)
SELECT
    annee_budgetaire
    , corp_empl
    , sal_moy_corp_emp
    , SUM(masse_salariale_corp_emp) OVER (PARTITION BY annee_budgetaire ORDER BY annee_budgetaire ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) As masse_salariale_an
FROM mass