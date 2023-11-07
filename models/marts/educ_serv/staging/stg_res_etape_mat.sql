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
    spi as (select fiche, id_eco, annee from {{ ref("spine") }}),

    mat_ele as (
        select
            spi.*,
            mat_ele.mat,
            mat_ele.grp,
            mat_ele.etat,
            mat_ele.id_mat_ele,
            mat.descr,
            res_etape = case
                met1.seq_etape
                when 1
                then mat_ele.res_etape_01
                when 2
                then mat_ele.res_etape_02
                when 3
                then mat_ele.res_etape_03
                when 4
                then mat_ele.res_etape_04
                when 5
                then mat_ele.res_etape_05
                when 6
                then mat_ele.res_etape_06
                when 7
                then mat_ele.res_etape_07
                when 8
                then mat_ele.res_etape_08
                when 9
                then mat_ele.res_etape_09
                when 10
                then mat_ele.res_etape_10
                when 11
                then mat_ele.res_etape_11
                when 12
                then mat_ele.res_etape_12
                when 13
                then mat_ele.res_etape_13
                when 14
                then mat_ele.res_etape_14
                when 15
                then mat_ele.res_etape_15
                when 16
                then mat_ele.res_etape_16
                when 17
                then mat_ele.res_etape_17
                when 18
                then mat_ele.res_etape_18
                when 19
                then mat_ele.res_etape_19
                when 20
                then mat_ele.res_etape_20
                when 21
                then mat_ele.res_etape_21
                when 22
                then mat_ele.res_etape_22
                when 23
                then mat_ele.res_etape_23
                when 24
                then mat_ele.res_etape_24
                when 25
                then mat_ele.res_etape_25
                when 26
                then mat_ele.res_etape_26
                when 27
                then mat_ele.res_etape_27
                when 28
                then mat_ele.res_etape_28
                when 29
                then mat_ele.res_etape_29
                when 30
                then mat_ele.res_etape_30
            end,
            leg_etape = case
                met1.seq_etape
                when 1
                then mg.leg_etape_01
                when 2
                then mg.leg_etape_02
                when 3
                then mg.leg_etape_03
                when 4
                then mg.leg_etape_04
                when 5
                then mg.leg_etape_05
                when 6
                then mg.leg_etape_06
                when 7
                then mg.leg_etape_07
                when 8
                then mg.leg_etape_08
                when 9
                then mg.leg_etape_09
                when 10
                then mg.leg_etape_10
                when 11
                then mg.leg_etape_11
                when 12
                then mg.leg_etape_12
                when 13
                then mg.leg_etape_13
                when 14
                then mg.leg_etape_14
                when 15
                then mg.leg_etape_15
                when 16
                then mg.leg_etape_16
                when 17
                then mg.leg_etape_17
                when 18
                then mg.leg_etape_18
                when 19
                then mg.leg_etape_19
                when 20
                then mg.leg_etape_20
                when 21
                then mg.leg_etape_21
                when 22
                then mg.leg_etape_22
                when 23
                then mg.leg_etape_23
                when 24
                then mg.leg_etape_24
                when 25
                then mg.leg_etape_25
                when 26
                then mg.leg_etape_26
                when 27
                then mg.leg_etape_27
                when 28
                then mg.leg_etape_28
                when 29
                then mg.leg_etape_29
                when 30
                then mg.leg_etape_30
            end,
            eval_res_etape = case
                met1.seq_etape
                when 1
                then mg.eval_res_etape_01
                when 2
                then mg.eval_res_etape_02
                when 3
                then mg.eval_res_etape_03
                when 4
                then mg.eval_res_etape_04
                when 5
                then mg.eval_res_etape_05
                when 6
                then mg.eval_res_etape_06
                when 7
                then mg.eval_res_etape_07
                when 8
                then mg.eval_res_etape_08
                when 9
                then mg.eval_res_etape_09
                when 10
                then mg.eval_res_etape_10
                when 11
                then mg.eval_res_etape_11
                when 12
                then mg.eval_res_etape_12
                when 13
                then mg.eval_res_etape_13
                when 14
                then mg.eval_res_etape_14
                when 15
                then mg.eval_res_etape_15
                when 16
                then mg.eval_res_etape_16
                when 17
                then mg.eval_res_etape_17
                when 18
                then mg.eval_res_etape_18
                when 19
                then mg.eval_res_etape_19
                when 20
                then mg.eval_res_etape_20
                when 21
                then mg.eval_res_etape_21
                when 22
                then mg.eval_res_etape_22
                when 23
                then mg.eval_res_etape_23
                when 24
                then mg.eval_res_etape_24
                when 25
                then mg.eval_res_etape_25
                when 26
                then mg.eval_res_etape_26
                when 27
                then mg.eval_res_etape_27
                when 28
                then mg.eval_res_etape_28
                when 29
                then mg.eval_res_etape_29
                when 30
                then mg.eval_res_etape_30
            end,
            met1.etape,
            met1.date_fin,
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
        left join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as met1
            on met1.id_eco = mat_ele.id_eco
            and met1.modele_etape = mat_ele.modele_etape
            and met1.date_fin <= oa.date_fin
            and met1.date_deb >= oa.date_deb
        left join
            {{ ref("i_gpm_t_mat") }} as mat
            on mat.id_eco = spi.id_eco
            and mat_ele.mat = mat.mat
        where
            mat_ele.res_som is not null  -- prendre en note le risque de perdre des données pour la compétence. a voir à le 2e itérations.
            and mat_ele.etat != 0  -- -- 0 = inactive, 1 = active, 5 = en continuation, 6 = equivalence, 8 = terminee

    ),

    row_num as (
        select

            annee,
            fiche,
            mat_ele.id_eco,
            mat,
            descr,
            grp,
            etat,
            etape,
            res_etape,
            mat_ele.leg_etape,
            mat_ele.eval_res_etape,
            row_number() over (
                partition by fiche, mat_ele.id_eco, mat, grp, etape
                order by mat_ele.id_mat_ele
            ) as seqid_res,
            reprise
        from mat_ele
        where res_etape is not null
    )

select
    annee,
    fiche,
    id_eco,
    mat,
    descr,
    grp,
    etat,
    etape,
    res_etape,
    leg_etape,
    eval_res_etape,
    reprise
from row_num
