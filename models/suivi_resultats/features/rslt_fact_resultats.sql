{{ config(alias='fact_resultats') }}

SELECT 
    spi.annee
    , spi.fiche
    , spi.niveau_scolaire
    , dim.course_code
    , dim.course_name
    , dim.course_group
    , res.resultat
    , CASE WHEN res.resultat_numerique < 60 THEN 1 ELSE 0 END AS is_echec
    , CASE WHEN res.resultat_numerique >= 60 AND res.resultat_numerique < 66 THEN 1 ELSE 0 END AS is_difficulty
    -- TODO : add an populate a is_reprise flag
FROM {{ ref('rslt_stg_spine') }} AS spi
LEFT JOIN {{ ref('rslt_stg_resultats') }} AS res
ON 
    spi.fiche = res.fiche AND
    spi.annee = res.annee
INNER JOIN {{ ref('tracked_courses') }} AS dim
ON 
    res.course_code = dim.course_code AND
    spi.niveau_scolaire = dim.level -- Only keep the results for the courses corresponding to the level the student is enrolled in