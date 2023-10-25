{#
dashboards store - helping students, one dashboard at a time.
copyright (c) 2023  sciance inc.

this program is free software: you can redistribute it and/or modify
it under the terms of the gnu affero general public license as
published by the free software foundation, either version 3 of the
license, or any later version.

this program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu affero general public license for more details.

you should have received a copy of the gnu affero general public license
along with this program.  if not, see <https://www.gnu.org/licenses/>.
#}
with
    step1 as (

        select
            mat_ele.annee,
            mat_ele.fiche,
            mat_ele.id_eco,
            mat_ele.mat,
            mat_ele.descr,
            mat_ele.grp,
            mat_ele.etat,
            mat_ele.etape,
            mat_ele.res_etape,
            leg.seuil_reus,
            mat_ele.eval_res_etape,
            mat_ele.leg_etape,
            cote.note_equiv,
            cote.cote,
            cote.indic_reus_echec,
            mat_ele.reprise
        from {{ ref("stg_res_etape_mat") }} as mat_ele
        left join
            {{ ref("i_gpm_t_leg") }} as leg
            on leg.id_eco = mat_ele.id_eco
            and leg.leg = mat_ele.leg_etape
        left join
            {{ ref("i_gpm_t_cotes") }} as cote
            on cote.id_eco = leg.id_eco
            and cote.leg = leg.leg
            and cote.cote = mat_ele.res_etape
    )
select
    annee,
    fiche,
    id_eco,
    mat,
    descr,
    grp,
    etat,
    reprise,
    etape,
    res_etape,
    case
        when cote is not null
        then note_equiv
        when isnumeric(res_etape) = 1
        then convert(int, res_etape)
        else null
    end as res_etape_num,
    case
        when cote is not null and indic_reus_echec = '1'
        then 'R'
        when cote is not null and indic_reus_echec = '2'
        then 'E'
        when (seuil_reus is null) or (isnumeric(res_etape) <> 1)
        then 'N/A'
        when res_etape >= seuil_reus
        then 'R'
        when res_etape < seuil_reus
        then 'E'
        else 'N/A'
    end as ind_reussite,
    case
        when eval_res_etape is not null and eval_res_etape <> '0' then 1 else 0
    end as evalue
from step1
