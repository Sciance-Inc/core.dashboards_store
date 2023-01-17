
{#
    Extract the grades from the e_ri_resultats and adapt them to fit with local exam table  .
#}

{{ config(
    alias='fact_evaluations_minist_sec4_sec5', 
    schema='res_etapes_staging'
    ) 
}}

SELECT DISTINCT
    fiche
    , ecole
    , matiere as code_matiere
    , annee 
    , resoffconv AS resultat
    , resoffconv AS resultat_numerique
    , CASE WHEN resoffconv > 59 THEN 'R' ELSE 'E' END AS code_reussite
FROM {{ ref('i_e_ri_resultats')}} AS resmin
WHERE mois_resultat = '6'