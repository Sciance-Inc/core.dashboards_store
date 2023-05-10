{{ config(alias='reporting_effectif_css') }}

SELECT
    annee
    , CONCAT(eco, ' - ' ,nom_eco) AS code_ecole
    , classe
    , ordre_ens
    , el_cod_niveau
    , plan_interv_ehdaa
    , difficulte
    , population
    , dist
    , grp_rep
    , COUNT(fiche) AS total_fiche
FROM {{ ref('eff_fact_effectif_css') }} 
GROUP BY 
    annee
    , eco
    , nom_eco
    , ordre_ens
    , population
    , el_cod_niveau
    , classe
    , dist
    , grp_rep
    , plan_interv_ehdaa
    , difficulte