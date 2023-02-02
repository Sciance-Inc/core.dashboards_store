
{#
    Extract the grades from the resultatsCompentenceEtape using the data provided by the rstep_dim_subject_evaluation.
#}

{{ config(
    alias='fact_evaluations_grades_from_dim'
    ) 
}}

WITH res as (
    SELECT 
        res.fiche,
        res.ecole, 
        dim.*,
        res.annee,
        res.resultat, 
        res.resultat_numerique, 
        res.code_reussite
    FROM {{ ref('rstep_dim_subject_evaluation') }} AS dim
    left JOIN {{ ref('i_gpm_edo_resultatsCompetenceEtape')}} AS res
    ON 
        dim.code_matiere = res.code_matiere and
        dim.code_etape = res.etape and
        dim.no_competence = res.no_competence
), resmin as (
    SELECT 
        resmin.fiche,
        RIGHT(resmin.ecole,3) as ecole, 
        dim.*,
        resmin.annee,
        resmin.resultat, 
        resmin.resultat_numerique, 
        resmin.code_reussite
    FROM {{ ref('rstep_dim_subject_evaluation')}} AS dim
    JOIN {{ ref('rstep_fact_evaluations_minist_sec4_sec5')}} AS resmin
    ON dim.code_matiere = resmin.code_matiere
	where resmin.ecole != ''
)

SELECT * FROM res
UNION
SELECT * FROM resmin