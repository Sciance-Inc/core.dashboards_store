{{ config(alias='report_effectif_css') }}


SELECT
    annee
    , CONCAT(eco, ' - ' ,nom_eco) AS code_ecole
    , ordre_ens
    , cod_niveau_scolaire
    , CASE WHEN plan_interv_ehdaa = 1 THEN 'Oui' ELSE 'Non' END AS plan_interv_ehdaa
    , difficulte
    , CASE
        WHEN population = 'prescolaire' THEN 'Prescolaire'
        WHEN population = 'primaire_reg' THEN 'Primaire régulier'
        WHEN population = 'primaire_adapt' THEN 'Primaire adapté'
        WHEN population = 'secondaire_reg' THEN 'Secondaire régulier'
        WHEN population = 'secondaire_adapt' THEN 'Secondaire adapté'
        ELSE population
    END as population
    , sexe
    , dist
    , grp_rep
    , COUNT(code_perm) AS total_ele
FROM {{ ref('eff_fact_effectif_css') }}
GROUP BY 
    annee
    , eco
    , sexe
    , nom_eco
    , ordre_ens
    , population
    , cod_niveau_scolaire
    , dist
    , grp_rep
    , plan_interv_ehdaa
    , difficulte