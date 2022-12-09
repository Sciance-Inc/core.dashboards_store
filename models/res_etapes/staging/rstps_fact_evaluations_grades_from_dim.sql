
{#
    Extract the grades from the resultatsCompentenceEtape using the data provided by the rstps_dim_subject_evaluation.
#}

{{ config(
    alias='rstps_fact_evaluations_grades_from_dim', 
    schema='res_etapes_staging'
    ) 
}}

SELECT 
    res.fiche,
    res.ecole, 
    dim.*,
    res.annee,
    res.resultat, 
    res.resultat_numerique, 
    res.code_reussite
FROM {{ ref('rstps_dim_subject_evaluation') }} AS dim
JOIN {{ ref('i_gpm_edo_resultatsCompetenceEtape')}} AS res
ON 
    dim.code_matiere = res.code_matiere and
    dim.code_etape = res.etape and
    dim.no_competence = res.no_competence
