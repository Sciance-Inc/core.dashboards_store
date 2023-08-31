{#
    Blend together the default and the customs table (not yet implemented)
#}
{{
    config(
        alias="fact_evaluations_grades",
    )
}}

select
    annee,
    ecole,
    fiche,
    friendly_name,
    resultat,
    resultat_numerique,
    -- make the code reussite a boolean to ease the computation of summary statistics
    case when code_reussite = 'R' then 1 else 0 end as cod_reussite,
    -- Create a customly thresolded code reussite.
    case
        when
            resultat_numerique
            >= {{ var("res_epreuves", {"threshold": 70})["threshold"] }}
        then 1
        else 0
    end as cod_reussite_threshold
from {{ ref("rstep_fact_evaluations_grades_from_dim") }}
where resultat_numerique is not null
