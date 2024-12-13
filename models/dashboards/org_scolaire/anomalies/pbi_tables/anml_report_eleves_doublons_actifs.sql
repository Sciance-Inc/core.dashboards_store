{#
    Trouver des élèves actives qui étaient actives deux fois par l'année
#}
{{ config(alias="report_eleves_doublons_actifs") }}

with
    eleves_actives_avec_ecoles as (
        select
            fiche,
            annee,
            eco.school_friendly_name,
            count(eco.school_friendly_name) over (partition by fiche, annee) as duplicat
        from {{ ref("anml_stg_population") }} as elv_act
        inner join {{ ref("dim_mapper_schools") }} as eco on elv_act.id_eco = eco.id_eco
    ),
    -- Touver les élèves doublons
    eleves_duplicats as (
        select
            fiche,
            annee,
            min(school_friendly_name) as premiere_ecole,
            max(school_friendly_name) as deuxieme_ecole
        from eleves_actives_avec_ecoles
        where duplicat > 1
        group by fiche, annee
    )

select
    fiche,
    annee,
    premiere_ecole,
    deuxieme_ecole,
    {{ dbt_utils.generate_surrogate_key(["annee", "premiere_ecole"]) }} as filter_key
from eleves_duplicats
