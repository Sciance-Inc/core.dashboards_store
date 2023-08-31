select distinct ele.code_perm, eco.id_eco, eco.annee
from {{ ref("i_gpm_e_dan") }} as eledan
left join {{ ref("i_gpm_t_eco") }} as eco on eledan.id_eco = eco.id_eco
left join {{ ref("i_gpm_e_ele") }} as ele on eledan.fiche = ele.fiche
where
    eledan.statut_don_an = 'A'
    and (
        (eledan.ordre_ens = '1' and eledan.grp_rep in ('MA4', 'MA5', 'M41', 'M42'))

        or (
            eledan.ordre_ens = '2'
            and (eledan.grp_rep not like '9%' or eledan.grp_rep is null)
            and (eledan.grp_rep != '008' or eledan.grp_rep is null)
        )
    )
