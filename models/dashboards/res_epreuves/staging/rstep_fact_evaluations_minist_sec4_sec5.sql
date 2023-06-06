
{#
    Extract the grades from the e_ri_resultats and adapt them to fit with local exam table  .
#}

{{ config(
    alias='fact_evaluations_minist_sec4_sec5', 
    schema='res_epreuves_staging'
    ) 
}}
WITH resmin AS (
    SELECT DISTINCT
        fiche
        , ecole
        , matiere AS code_matiere
        , annee 
        , res_off_conv AS resultat
        , res_off_conv AS resultat_numerique
        , CASE WHEN res_off_conv > 59 THEN 'R' ELSE 'E' END AS code_reussite
    FROM {{ ref('i_e_ri_resultats')}} AS resmin
    WHERE mois_resultat = '6' 
        AND annee NOT IN ('2019', '2020')
        AND type_form_charl = 'FG'
        AND secteur_enseign_freq = 'JE'
        AND ecole LIKE ('{{ var('res_epreuves')['cod_css'] }}' )
        AND res_off_conv != '' 
)
SELECT * FROM resmin