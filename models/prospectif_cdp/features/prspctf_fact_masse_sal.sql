{{ config(alias='fact_masse_sal') }}

WITH src AS (
    SELECT 
        pcb.*
        , tce.DESCR as descr
    FROM {{ ref('i_pai_cum_budg') }} AS pcb
    INNER JOIN {{ ref('i_pai_tab_corp_empl') }} AS tce 
        ON pcb.corp_emploi = tce.CORP_EMPL
    WHERE  (pcb.code_pmnt_ded NOT LIKE '402%') AND (pcb.code_pmnt_ded NOT LIKE '401%')
) 

SELECT 
    annee_budgetaire
    , corp_emploi
    , SUM(cumulatif) as masse_salariale
FROM src
GROUP BY annee_budgetaire, corp_emploi



