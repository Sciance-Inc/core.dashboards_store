{#
Dashboards Store - Helping students, one dashboard at a time.
Copyright (C) 2023  Sciance Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
#}
with
    spi as (
        select fiche, id_eco, annee
        from {{ ref("spine") }}
        where annee >= {{ store.get_current_year() }} - 10
    ),

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
            end as ind_reprise
        from spi
        inner join
            {{ ref("i_gpm_e_mat_ele") }} as me
            on spi.fiche = me.fiche
            and spi.id_eco = me.id_eco
        inner join {{ ref("i_gpm_t_mat_grp") }} as mg on me.id_mat_grp = mg.id_mat_grp
        inner join {{ ref("i_gpm_e_obj") }} as o on o.id_mat_ele = me.id_mat_ele
        inner join
            {{ ref("i_gpm_t_obj_mat") }} as om
            on om.id_eco = spi.id_eco
            and om.mat = me.mat
            and om.id_obj_mat = o.id_obj_mat
            and om.obj_02 is null
            and om.obj_03 is null
            and om.obj_04 is null
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
            ind_reprise
        from mat_ele
        where res_comp is not null
    )
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
    ind_reprise
from row_num
