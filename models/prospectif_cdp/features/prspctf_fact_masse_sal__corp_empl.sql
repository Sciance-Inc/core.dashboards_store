{{ config(alias='fact_masse_sal_corp_emp') }}

WITH src AS (
    SELECT 
        pcb.*
        , tce.DESCR as descr
    FROM {{ ref('i_pai_cum_budg') }} AS pcb
    INNER JOIN {{ ref('i_pai_tab_corp_empl') }} AS tce 
        ON pcb.corp_empl = tce.CORP_EMPL
    WHERE  (code_pmnt_ded like '1%'or code_pmnt_ded like '2%' )                 -- salaire brute (1% et 2%)
) 

SELECT 
    annee_budgetaire
    , corp_empl
    , avg(cumulatif) as masse_salariale
FROM src
GROUP BY annee_budgetaire, corp_empl




