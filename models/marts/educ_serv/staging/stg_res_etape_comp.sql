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
            mat_ele.mat,
            mat_ele.grp,
            mat_ele.etat,
            mat_ele.id_mat_ele,
            met1.etape,
            met1.date_deb as date_fin_etape,
            met1.date_fin as date_debut_etape,
            om.id_obj_mat,
            om.obj_01 as no_comp,
            res_comp = case
                met1.seq_etape
                when 1
                then o.res_obj_01
                when 2
                then o.res_obj_02
                when 3
                then o.res_obj_03
                when 4
                then o.res_obj_04
                when 5
                then o.res_obj_05
                when 6
                then o.res_obj_06
                when 7
                then o.res_obj_07
                when 8
                then o.res_obj_08
                when 9
                then o.res_obj_09
                when 10
                then o.res_obj_10
                when 11
                then o.res_obj_11
                when 12
                then o.res_obj_12
                when 13
                then o.res_obj_13
                when 14
                then o.res_obj_14
                when 15
                then o.res_obj_15
                when 16
                then o.res_obj_16
                when 17
                then o.res_obj_17
                when 18
                then o.res_obj_18
                when 19
                then o.res_obj_19
                when 20
                then o.res_obj_20
                when 21
                then o.res_obj_21
                when 22
                then o.res_obj_22
                when 23
                then o.res_obj_23
                when 24
                then o.res_obj_24
                when 26
                then o.res_obj_26
                when 27
                then o.res_obj_27
                when 28
                then o.res_obj_28
                when 29
                then o.res_obj_29
                when 30
                then o.res_obj_30
            end,
            legende = case
                when
                    met1.seq_etape = coalesce(
                        case when omg.etape_eval_30 = '1' then 30 else null end,
                        case when omg.etape_eval_29 = '1' then 29 else null end,
                        case when omg.etape_eval_28 = '1' then 28 else null end,
                        case when omg.etape_eval_27 = '1' then 27 else null end,
                        case when omg.etape_eval_26 = '1' then 26 else null end,
                        case when omg.etape_eval_25 = '1' then 25 else null end,
                        case when omg.etape_eval_24 = '1' then 24 else null end,
                        case when omg.etape_eval_23 = '1' then 23 else null end,
                        case when omg.etape_eval_22 = '1' then 22 else null end,
                        case when omg.etape_eval_21 = '1' then 21 else null end,
                        case when omg.etape_eval_20 = '1' then 20 else null end,
                        case when omg.etape_eval_19 = '1' then 19 else null end,
                        case when omg.etape_eval_18 = '1' then 18 else null end,
                        case when omg.etape_eval_17 = '1' then 17 else null end,
                        case when omg.etape_eval_16 = '1' then 16 else null end,
                        case when omg.etape_eval_15 = '1' then 15 else null end,
                        case when omg.etape_eval_14 = '1' then 14 else null end,
                        case when omg.etape_eval_13 = '1' then 13 else null end,
                        case when omg.etape_eval_12 = '1' then 12 else null end,
                        case when omg.etape_eval_11 = '1' then 11 else null end,
                        case when omg.etape_eval_10 = '1' then 10 else null end,
                        case when omg.etape_eval_09 = '1' then 9 else null end,
                        case when omg.etape_eval_08 = '1' then 8 else null end,
                        case when omg.etape_eval_07 = '1' then 7 else null end,
                        case when omg.etape_eval_06 = '1' then 6 else null end,
                        case when omg.etape_eval_05 = '1' then 5 else null end,
                        case when omg.etape_eval_04 = '1' then 4 else null end,
                        case when omg.etape_eval_03 = '1' then 3 else null end,
                        case when omg.etape_eval_02 = '1' then 2 else null end,
                        case when omg.etape_eval_01 = '1' then 1 else null end
                    )
                then mg.leg_obj_term
                else mg.leg_obj_non_term
            end,
            etape_eval = case
                met1.seq_etape
                when 1
                then omg.etape_eval_01
                when 2
                then omg.etape_eval_02
                when 3
                then omg.etape_eval_03
                when 4
                then omg.etape_eval_04
                when 5
                then omg.etape_eval_05
                when 6
                then omg.etape_eval_06
                when 7
                then omg.etape_eval_07
                when 8
                then omg.etape_eval_08
                when 9
                then omg.etape_eval_09
                when 10
                then omg.etape_eval_10
                when 11
                then omg.etape_eval_11
                when 12
                then omg.etape_eval_12
                when 13
                then omg.etape_eval_13
                when 14
                then omg.etape_eval_14
                when 15
                then omg.etape_eval_15
                when 16
                then omg.etape_eval_16
                when 17
                then omg.etape_eval_17
                when 18
                then omg.etape_eval_18
                when 19
                then omg.etape_eval_19
                when 20
                then omg.etape_eval_20
                when 21
                then omg.etape_eval_21
                when 22
                then omg.etape_eval_22
                when 23
                then omg.etape_eval_23
                when 24
                then omg.etape_eval_24
                when 25
                then omg.etape_eval_25
                when 26
                then omg.etape_eval_26
                when 27
                then omg.etape_eval_27
                when 28
                then omg.etape_eval_28
                when 29
                then omg.etape_eval_29
                when 30
                then omg.etape_eval_30
            end,
            case
                when left(mat_ele.grp, 1) not like '[%0-9]%'  -- grp starting with a letter = retake
                then 1
                else 0
            end as reprise
        from spi
        left join
            {{ ref("i_gpm_e_mat_ele") }} as mat_ele
            on spi.fiche = mat_ele.fiche
            and spi.id_eco = mat_ele.id_eco
        left join
            {{ ref("i_gpm_t_mat_grp") }} as mg on mat_ele.id_mat_grp = mg.id_mat_grp
        left join
            {{ ref("i_gpm_t_org_annee") }} as oa
            on oa.annee = spi.annee
            and spi.annee >= {{ store.get_current_year() }} - 10

        left join {{ ref("i_gpm_e_obj") }} as o on o.id_mat_ele = mat_ele.id_mat_ele
        left join
            {{ ref("i_gpm_t_obj_mat") }} as om
            on om.id_eco = spi.id_eco
            and om.mat = mat_ele.mat
            and om.id_obj_mat = o.id_obj_mat
            and om.obj_02 is null
            and om.obj_03 is null
            and om.obj_04 is null
        left join
            {{ ref("i_gpm_t_obj_mat_grp") }} as omg
            on omg.id_obj_mat = om.id_obj_mat
            and omg.id_mat_grp = mat_ele.id_mat_grp

        left join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as met1
            on met1.id_eco = spi.id_eco
            and met1.modele_etape = mat_ele.modele_etape
            and met1.date_fin <= oa.date_fin
            and met1.date_fin >= oa.date_deb
        where
            mat_ele.modele_etape is not null
            -- and planif like 'REG'
            and mat_ele.res_som is not null  -- prendre en note le risque de perdre des données pour la compétence. a voir à le 2e itérations.
            and mat_ele.etat != 0  -- -- 0 = inactive, 1 = active, 5 = en continuation, 6 = equivalence, 8 = terminee
    -- and spi.fiche = 410753 --and spi.annee = 2022
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
            etape,
            date_debut_etape,
            date_fin_etape,
            id_obj_mat,
            no_comp,
            res_comp,
            etape_eval,
            legende,
            row_number() over (
                partition by fiche, id_eco, mat, grp, etape, no_comp
                order by id_mat_ele desc
            ) as seqid_res,
            reprise
        from mat_ele
        where res_comp is not null
    )
select *
from row_num
where seqid_res = 1
