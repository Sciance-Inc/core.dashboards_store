{#
    Les élèves qui sont mal placés dans les classes selon l'ordre enseignement
#}
{{ config(alias="report_classe_ordre_enseignement") }}

with
    -- Prendre tous les élèves de la population
    eleves_actives as (
        select popl.fiche, popl.id_eco, statut_don_an, ordre_ens, classe
        from {{ ref("i_gpm_e_dan") }} as dan
        inner join
            {{ ref("anml_stg_population") }} as popl
            on popl.id_eco = dan.id_eco
            and popl.fiche = dan.fiche

    ),
    -- Prendre les nom d'école avce l'année
    eleves_actives_avec_ecoles as (
        select fiche, annee, eco.school_friendly_name, elv_act.id_eco, ordre_ens, classe
        from eleves_actives as elv_act
        inner join {{ ref("dim_mapper_schools") }} as eco on elv_act.id_eco = eco.id_eco

    ),
    -- Trouver les élèves qui sont mal placés dans les classes selon l'ordre
    -- enseignement
    eleves_classe_conflit as (
        select
            fiche,
            annee,
            school_friendly_name,
            id_eco,
            elv_act_ecl.ordre_ens,
            desc_ordre_ens,
            classe
        from eleves_actives_avec_ecoles as elv_act_ecl
        inner join
            {{ ref("anml_dim_ordre_enseignement") }} as dim
            on dim.ordre_ens = elv_act_ecl.ordre_ens  -- Prendre la description de l'ordre d`enseignement 
        where
            (elv_act_ecl.ordre_ens in (1, 2) and classe is not null)
            or (
                elv_act_ecl.ordre_ens = 3
                and classe not in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I')
            )
            or (
                elv_act_ecl.ordre_ens = 4
                and classe not in ('1', '2', '3', '4', '5', '6', '7', '8')
            )
    )

select
    fiche,
    annee,
    school_friendly_name,
    ordre_ens,
    desc_ordre_ens,
    classe,
    {{ dbt_utils.generate_surrogate_key(["annee", "school_friendly_name"]) }}
    as filter_key
from eleves_classe_conflit
