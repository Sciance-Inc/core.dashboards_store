{{ config(alias='ratio_anc') }}

SELECT
	annee_budgetaire
	, AVG(CAST(anc_2ans AS FLOAT)) AS ratio_anc
FROM {{ ref('prspctf_fact_anc_2y') }} 

GROUP BY annee_budgetaire


