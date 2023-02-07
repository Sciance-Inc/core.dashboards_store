{{ config(alias='fact_taux_roulement_personnel') }}

WITH sal_moyen AS sm
(  
    SELECT
        annee_budgetaire
        , masse_salariale
        , corp_empl
    FROM {{ ref('fact_masse_sal_corp_emp') }}
)
, nombre_emp_quitter AS nb
(  
    SELECT
        nombre_emp_quitter
      , corp_empl
      , annee_budgetaire
    FROM {{ ref('fact_emp_quitter') }}
)
, masse_salariale AS ms
(  
    SELECT
        annee_budgetaire
        , masse_salariale 
    FROM {{ ref('fact_masse_sal') }}
)

SELECT
    (sm.masse_salariale * nb.nombre_emp_quitter / ms.masse_salariale) as taux_roulement_personnel
    , nb.corp_empl
FROM nb 
	JOIN sm ON nb.corp_empl = sm.corp_empl AND nb.annee_budgetaire = sm.annee_budgetaire
  	JOIN ms ON sm.annee_budgetaire = ms.annee_budgetaire 
GROUP BY nb.corp_empl
