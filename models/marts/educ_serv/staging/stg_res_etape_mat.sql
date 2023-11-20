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
            spi.*,
            mat_ele.mat,
            mat_ele.grp,
            mat_ele.etat,
            mat_ele.id_mat_ele,
            mat.descr,
            res_etape = case
                met1.seq_etape
                {% for i in range(1, 31) %}
                    when {{ i }} then mat_ele.res_etape_{{ "%02d" % i }}
                {% endfor %}
            end,
            leg_etape = case
                met1.seq_etape
                {% for i in range(1, 31) %}
                    when {{ i }} then mg.leg_etape_{{ "%02d" % i }}
                {% endfor %}
            end,
            eval_res_etape = case
                met1.seq_etape
                {% for i in range(1, 31) %}
                    when {{ i }} then mg.eval_res_etape_{{ "%02d" % i }}
                {% endfor %}
            end,
            met1.etape,
            met1.date_fin,
            case
                when left(mat_ele.grp, 1) not like '[%0-9]%'  -- grp starting with a letter = retake
                then 1
                else 0
            end as ind_reprise
        from {{ ref("stg_yearly_eleve_matiere_groupe") }} as emgrp_yearly
        left join
            {{ ref("i_gpm_e_mat_ele") }} as mat_ele
            on spi.fiche = mat_ele.fiche
            and spi.id_eco = mat_ele.id_eco
        left join
            {{ ref("i_gpm_t_mat_grp") }} as mg on mat_ele.id_mat_grp = mg.id_mat_grp
        left join {{ ref("i_gpm_t_org_annee") }} as oa on oa.annee = spi.annee
        left join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as met1
            on met1.id_eco = mat_ele.id_eco
            and met1.modele_etape = mat_ele.modele_etape
            and met1.date_fin between oa.date_deb and oa.date_fin
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
            ind_reprise
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
    ind_reprise
from row_num
where seqid_res = 1
