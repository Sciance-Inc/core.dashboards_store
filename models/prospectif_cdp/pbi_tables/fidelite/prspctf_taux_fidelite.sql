{{ config(alias='taux_fidelite') }}

SELECT
    annee_budgetaire
    , 1 - (CAST(CAST(SUM(demission_volontaire) AS float) / CAST(COUNT(demission_volontaire) AS float) AS decimal(5,5))) AS 'ratio_fidelisation'
FROM {{ ref('prspctf_fact_demission') }} 

GROUP BY annee_budgetaire 