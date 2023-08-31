with
    dan as (
        select dan.fiche, eco.annee, eco.eco, dan.date_deb, dan.id_eco
        from {{ ref("i_gpm_e_dan") }} as dan
        left join {{ ref("i_gpm_t_eco") }} as eco on dan.id_eco = eco.id_eco
        where dan.statut_don_an = 'A'
    ),

    fiche as (
        select stg.code_perm, stg.id_eco, stg.annee, ele.fiche, stg.population
        from {{ ref("stg_populations_fgj") }} as stg
        left join {{ ref("i_gpm_e_ele") }} as ele on stg.code_perm = ele.code_perm
    )

select
    fiche.*,
    dan.eco,
    row_number() over (
        partition by code_perm, fiche.annee order by date_deb desc
    ) as seqid
from fiche
left join dan on dan.fiche = fiche.fiche and dan.id_eco = fiche.id_eco
