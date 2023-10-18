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
    res_mat as (
        select
            -- FROM yearly_student
            res_mat.code_perm,
            res_mat.id_eco,
            res_mat.annee,
            res_mat.fiche,
            res_mat.population,
            res_mat.eco,
            res_mat.code_ecole,
            res_mat.ordre_ens,
            res_mat.genre,
            res_mat.plan_interv_ehdaa,
            res_mat.niveau_scolaire,
            -- FROM mat_ele
            res_mat.id_mat_ele,
            res_mat.mat,
            res_mat.grp,
            res_mat.etat,
            res_mat.reprise
        from {{ ref("fact_res_bilan_mat") }} as res_mat
    ),

    obj_matiere as (
        select
            res_mat.*,
            dim.obj_01 as no_competence,
            dim.descr,
            dim.descr_abreg,
            comp.res_final_obj  -- Res compétence de la matière
        from res_mat
        left join
            {{ ref("i_gpm_e_obj") }} as comp
            on res_mat.fiche = comp.fiche
            and res_mat.id_mat_ele = comp.id_mat_ele
        left join
            {{ ref("i_gpm_t_obj_mat") }} as dim on comp.id_obj_mat = dim.id_obj_mat
        where
            (
                (comp.res_final_obj like '%[0-9]%' or comp.res_final_obj in ('R', 'NR'))
                and (comp.res_final_obj is not null)
            )
    ),

    filtering as (
        select
            code_perm,
            id_eco,
            annee,
            fiche,
            population,
            eco,
            code_ecole,
            ordre_ens,
            genre,
            plan_interv_ehdaa,
            niveau_scolaire,
            id_mat_ele,
            mat,
            grp,
            etat,
            reprise,
            no_competence,
            descr,
            descr_abreg,
            case
                when obj_matiere.res_final_obj in ('NR')
                then '0'
                when obj_matiere.res_final_obj in ('R')
                then '100'
                else obj_matiere.res_final_obj
            end as res_num_comp
        from obj_matiere
    )

select *
from filtering
