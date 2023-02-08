{{ config(alias='couts_de_roulement') }}

WITH src AS (
    SELECT
        msce.*
        , ms.masse_salariale_an
        , emoq.nb_empl_aremp
    FROM {{ ref('prspctf_fact_masse_sal__corp_empl') }} AS msce
    LEFT JOIN {{ ref('prspctf_fact_masse_sal') }} AS ms
        ON msce.annee_budgetaire = ms.annee_budgetaire
    LEFT JOIN {{ ref('prspctf_fact_emp_quitter') }} AS emoq
        ON msce.annee_budgetaire = emoq.annee_budgetaire    
        AND msce.corp_empl = emoq.corp_empl
), agg AS(
    SELECT 
        annee_budgetaire
        ,masse_salariale_an
        ,sum(masse_salariale*nb_empl_aremp) as couts_de_roulement

    FROM src
    GROUP BY annee_budgetaire, masse_salariale_an
)
SELECT
    annee_budgetaire        
    ,(couts_de_roulement/masse_salariale_an)*100 AS ratio_couts_roulement
 FROM agg
