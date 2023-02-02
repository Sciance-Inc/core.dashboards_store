
{#
    Blend together the default and the customs table (not yet implemented)
#}

{{ config(
    alias='fact_evaluations_grades', 
    ) 
}}

SELECT 
    annee,
    ecole,
    fiche,
    friendly_name,
    resultat,
    resultat_numerique,
    -- make the code reussite a boolean to ease the computation of summary statistics
    CASE 
        WHEN code_reussite = 'R' THEN 1
        ELSE 0
    END AS cod_reussite,
    -- Create a customly thresolded code reussite.
    CASE 
        WHEN resultat_numerique >= {{ var('res_epreuves', {'threshold': 70})['threshold'] }} THEN 1
        ELSE 0
    END AS cod_reussite_threshold
FROM {{ ref('rstep_fact_evaluations_grades_from_dim') }}
WHERE resultat_numerique IS NOT NULL 