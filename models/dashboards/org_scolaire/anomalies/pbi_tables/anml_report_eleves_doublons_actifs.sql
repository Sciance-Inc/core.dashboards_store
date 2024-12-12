    {#
    Trouver des élèves actives qui étaient actives deux fois par l`année
#}
{{ config(alias="report_eleves_doublons_actifs") }}

with
    -- Prendre tous les élèves actives
    eleves_actives as (
        select fiche, id_eco, statut_don_an
        from {{ ref("i_gpm_e_dan") }} as dan
        where statut_don_an = 'A' 
    ),
    -- Mapper avec des écoles 
    eleves_actives_avec_ecoles as (
        select
            fiche,
            annee,
            eco.school_friendly_name,
            elv_act.id_eco,
            count(eco.school_friendly_name) over (partition by fiche, annee) as duplicat
        from eleves_actives as elv_act
        inner join {{ ref("dim_mapper_schools") }} as eco on elv_act.id_eco = eco.id_eco
        where annee > 2009 and eco.eco < '099'  -- Prendre des écoles de CSSPI 
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