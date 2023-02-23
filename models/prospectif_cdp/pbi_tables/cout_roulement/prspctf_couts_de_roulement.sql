{{ config(alias='couts_de_roulement') }}

WITH src AS (
    SELECT
        msce.*
        , emoq.nb_empl_aremp
    FROM {{ ref('prspctf_fact_masse_sal_corp_empl') }} AS msce
    LEFT JOIN {{ ref('prspctf_fact_emp_quitter') }} AS emoq
        ON msce.annee_budgetaire = emoq.annee_budgetaire    
        AND msce.corp_empl = emoq.corp_empl
), agg AS(
    SELECT 
        annee_budgetaire
        ,masse_salariale_an
        ,sum(sal_moy_corp_emp*nb_empl_aremp) as couts_de_roulement

    FROM src
    GROUP BY annee_budgetaire, masse_salariale_an
)
SELECT
    annee_budgetaire        
    ,CAST(((couts_de_roulement/masse_salariale_an)*100) AS DECIMAL(5,2)) AS ratio_couts_roulement
 FROM agg
