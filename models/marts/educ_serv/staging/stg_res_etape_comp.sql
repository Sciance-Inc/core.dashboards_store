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
    stg_yearly_comp as (
        select
            emgrp_yearly_comp.fiche,
            emgrp_yearly_comp.id_eco,
            emgrp_yearly_comp.annee,
            emgrp_yearly_comp.mat,
            emgrp_yearly_comp.grp,
            emgrp_yearly_comp.etat,
            emgrp_yearly_comp.id_mat_ele,
            emgrp_yearly_comp.modele_etape,
            emgrp_yearly_comp.id_mat_grp,
            emgrp_yearly_comp.date_deb,
            emgrp_yearly_comp.date_fin,
            emgrp_yearly_comp.leg_obj_term,
            emgrp_yearly_comp.leg_obj_non_term,
            emgrp_yearly_comp.no_comp,
            met1.etape,
            met1.date_deb as date_fin_etape,
            met1.date_fin as date_debut_etape,
            o.id_obj_mat,
            res_comp = case
                met1.seq_etape
                {% for i in range(1, 31) %}
                    when {{ i }} then o.res_obj_{{ "%02d" % i }}
                {% endfor %}
            end,
            legende = case
                when
                    met1.seq_etape = coalesce(
                        {% for i in range(1, 31) %}
                            {% if i < 30 %}
                                case
                                    when
                                        emgrp_yearly_comp.etape_eval_{{ "%02d" % i }}
                                        = '1'
                                    then {{ i }}
                                    else null
                                end,
                            {% else %}
                                case
                                    when
                                        emgrp_yearly_comp.etape_eval_{{ "%02d" % i }}
                                        = '1'
                                    then {{ i }}
                                    else null
                                end
                            {% endif %}
                        {% endfor %}
                    )
                then emgrp_yearly_comp.leg_obj_term
                else emgrp_yearly_comp.leg_obj_non_term
            end,
            etape_eval = case
                met1.seq_etape
                {% for i in range(1, 31) %}
                    when {{ i }} then emgrp_yearly_comp.etape_eval_{{ "%02d" % i }}
                {% endfor %}
            end,
            case
                when left(emgrp_yearly_comp.grp, 1) not like '[%0-9]%'  -- grp starting with a letter = retake
                then 1
                else 0
            end as ind_reprise
        from
            {{ ref("stg_yearly_eleve_matiere_groupe_competence") }} as emgrp_yearly_comp
        inner join
            {{ ref("i_gpm_e_obj") }} as o
            on o.id_mat_ele = emgrp_yearly_comp.id_mat_ele
            and o.id_obj_mat = emgrp_yearly_comp.id_obj_mat
        inner join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as met1
            on met1.id_eco = emgrp_yearly_comp.id_eco
            and met1.modele_etape = emgrp_yearly_comp.modele_etape
            and met1.date_fin
            between emgrp_yearly_comp.date_deb and emgrp_yearly_comp.date_fin
        where
            emgrp_yearly_comp.modele_etape is not null
            and emgrp_yearly_comp.res_som is not null  -- prendre en note le risque de perdre des données pour la compétence. a voir à le 2e itérations.
            and emgrp_yearly_comp.etat != 0  -- -- 0 = inactive, 1 = active, 5 = en continuation, 6 = equivalence, 8 = terminee
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
            ind_reprise
        from stg_yearly_comp
        where res_comp is not null
    )
select *
from row_num
where seqid_res = 1
