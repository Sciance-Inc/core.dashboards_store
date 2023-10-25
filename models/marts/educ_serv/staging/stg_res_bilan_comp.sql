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
    spi as (select fiche, id_eco, annee from {{ ref("spine") }}),

    mat_ele as (
        select
            spi.fiche,
            spi.id_eco,
            spi.annee,
            me.mat,
            me.grp,
            me.etat,
            me.id_mat_ele,
            om.id_obj_mat,
            om.obj_01 as no_comp,
            mg.leg_obj_final as legende,
            o.res_final_obj as res_comp,
            mg.eval_res_obj_final as eval_res_comp,
            case
                when left(me.grp, 1) not like '[%0-9]%'  -- grp starting with a letter = retake
                then 1
                else 0
            end as reprise
        from spi
        left join
            {{ ref("i_gpm_e_mat_ele") }} as me
            on spi.fiche = me.fiche
            and spi.id_eco = me.id_eco
        left join {{ ref("i_gpm_t_mat_grp") }} as mg on me.id_mat_grp = mg.id_mat_grp
        left join
            {{ ref("i_gpm_t_org_annee") }} as oa
            on oa.annee = spi.annee
            and spi.annee >= {{ store.get_current_year() }} - 10

        left join {{ ref("i_gpm_e_obj") }} as o on o.id_mat_ele = me.id_mat_ele
        left join
            {{ ref("i_gpm_t_obj_mat") }} as om
            on om.id_eco = spi.id_eco
            and om.mat = me.mat
            and om.id_obj_mat = o.id_obj_mat
            and om.obj_02 is null
            and om.obj_03 is null
            and om.obj_04 is null
        left join
            {{ ref("i_gpm_t_obj_mat_grp") }} as omg
            on omg.id_obj_mat = om.id_obj_mat
            and omg.id_mat_grp = me.id_mat_grp

        left join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as met1
            on met1.id_eco = spi.id_eco
            and met1.modele_etape = me.modele_etape
            and met1.date_fin <= oa.date_fin
            and met1.date_fin >= oa.date_deb
        where

            me.res_som is not null  -- prendre en note le risque de perdre des données pour la compétence. a voir à le 2e itérations.
            and me.etat != 0  -- -- 0 = inactive, 1 = active, 5 = en continuation, 6 = equivalence, 8 = terminee

    ),
    row_num as (
        select
            fiche,
            id_eco,
            annee,
            mat,
            grp,
            etat,
            id_mat_ele,
            id_obj_mat,
            no_comp,
            res_comp,
            eval_res_comp,
            legende,
            row_number() over (
                partition by fiche, id_eco, mat, grp, no_comp order by id_mat_ele desc
            ) as seqid_res,
            reprise
        from mat_ele
        where res_comp is not null
    )
select *
from row_num
where seqid_res = 1
