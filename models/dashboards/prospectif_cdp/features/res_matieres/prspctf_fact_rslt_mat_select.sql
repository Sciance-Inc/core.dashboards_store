

{{ config(alias='fact_rslt_mat_select') }}

WITH src AS( 
    SELECT 
        res.annee
        , res.fiche
        , res.ecole
        , dim.*
        , res.resultat_numerique 
    FROM {{ ref('prspctf_dim_mat_selct') }} AS dim
    LEFT JOIN {{ ref('i_resultats_matieres_eleve')}} AS res
    ON 
        dim.code_matiere = res.code_matiere 
    WHERE resultat_numerique IS NOT NULL 
)

SELECT 
    annee
    , fiche
    , niveau_scolaire
    , MAX(res_fr) AS res_fr
    , MAX(res_maths) AS res_maths    
    , MAX(res_ang) AS res_ang
    , MAX(res_sc) AS res_sc
    , MAX(res_his) AS res_his
FROM 
    (
    SELECT 
        annee
        , fiche
        , niveau_scolaire
        , CASE WHEN friendly_name = 'Français'  THEN resultat_numerique END AS res_fr
        , CASE WHEN friendly_name = 'Maths' THEN resultat_numerique END AS res_maths
        , CASE WHEN friendly_name = 'Anglais'  THEN resultat_numerique END AS res_ang
        , CASE WHEN friendly_name = 'Science' THEN resultat_numerique END AS res_sc
        , CASE WHEN friendly_name = 'Histoire' THEN resultat_numerique END AS res_his
    FROM src
    
) AS srctable 
 GROUP BY 
        annee
        , fiche
        , niveau_scolaire
