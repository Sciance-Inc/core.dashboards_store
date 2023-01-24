
{#
    Extract the grades from the e_ri_resultats and adapt them to fit with local exam table  .
#}

{{ config(
    alias='fact_evaluations_minist_sec4_sec5', 
    schema='res_etapes_staging'
    ) 
}}
WITH resmin AS (
    SELECT DISTINCT
        fiche
        , ecole
        , matiere AS code_matiere
        , annee 
        , resoffconv AS resultat
        , resoffconv AS resultat_numerique
        , CASE WHEN resoffconv > 59 THEN 'R' ELSE 'E' END AS code_reussite
    FROM {{ ref('i_e_ri_resultats')}} AS resmin
    WHERE mois_resultat = '6' AND annee NOT IN ('2019', '2020') AND typeformcharl = 'FG' AND secteurEnseignFreq = 'JE'
), AS srcmin (
    SELECT 
        ele.fiche
        , ele.annee 
        , resmin.ecole
        , resmin.code_matiere
        , resmin.resultat 
        , resmin.resultat_numerique 
    FROM {{ ref('i_e_ele')}} AS ele
    LEFT JOIN resmin AS resmin ON resmin.fiche = ele.fiche AND resmin.annee = ele.annee
)
SELECT * FROM srcmin