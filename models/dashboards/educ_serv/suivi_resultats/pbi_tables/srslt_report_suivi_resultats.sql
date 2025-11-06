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
{{ config(alias="report_suivi_resultats") }}

-- Creation of the current groupe matiere to allow selection by student/teacher group
with
    base as (
        select
            fiche,
            id_eco,
            ordre_ens,
            eco,
            nom_ecole,
            population,
            niveau_res,
            niveau_scolaire,
            grp_rep,
            class,
            dist,
            annee,
            code_matiere,
            groupe_matiere,
            discipline,
            case
                when max(annee) over (partition by fiche, discipline) = 2025
                then
                    first_value(groupe_matiere) over (
                        partition by fiche, discipline
                        order by annee desc
                        rows between unbounded preceding and unbounded following
                    )
                else null
            end as groupe_matiere_actu,
            semestrialisation,
            promotion_matiere,
            etat,
            description_matiere,
            res_num_som,
            is_reussite_mat,
            is_echec_mat,
            is_difficulte_mat,
            is_maitrise_mat,
            -- Comp 
            no_comp,
            res_num_comp,
            is_reussite_comp,
            is_echec_comp,
            is_difficulte_comp,
            is_maitrise_comp
        from {{ ref("srlt_semestrialisation_promomatiere_groupe_matiere") }}  
    -- collapse to one row per year #}
    ),
    yearly as (
        select
            -- Attributes 
            base.fiche,
            base.id_eco,
            annee,
            no_comp,
            description_matiere,
            -- Current and lagged stauts 
            max(
                case
                    when is_reussite_mat = 'R'
                    then 1
                    when is_reussite_mat = 'NR'
                    then 0
                    else null
                end
            ) as is_reussite_mat_yearly,
            case when max(is_echec_mat) = 1 then 1 else 0 end as is_echec_mat_yearly,
            case
                when max(is_difficulte_mat) = 1 then 1 else 0
            end as is_difficulte_mat_yearly,
            case
                when max(is_maitrise_mat) = 1 then 1 else 0
            end as is_maitrise_mat_yearly,
            max(
                case
                    when is_reussite_comp = 'R'
                    then 1
                    when is_reussite_comp = 'NR'
                    then 0
                    else null
                end
            ) as is_reussite_comp_yearly,
            case when max(is_echec_comp) = 1 then 1 else 0 end as is_echec_comp_yearly,
            case
                when max(is_difficulte_comp) = 1 then 1 else 0
            end as is_difficulte_comp_yearly,
            case
                when max(is_maitrise_comp) = 1 then 1 else 0
            end as is_maitrise_comp_yearly
        from base 
        group by base.fiche, base.id_eco, annee, description_matiere, no_comp
    )
    -- Compute the lagged success / failure status
    ,
    lagged as (
        select
            -- Attributes 
            fiche,
            id_eco,
            annee,
            description_matiere,
            no_comp,
            -- Current and lagged stauts 
            lag(is_reussite_mat_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_reussite_mat_lagged,
            lag(is_echec_mat_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_echec_mat_lagged,
            lag(is_difficulte_mat_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_difficulte_mat_lagged,
            lag(is_maitrise_mat_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_maitrise_mat_lagged,
            lag(is_reussite_comp_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_reussite_comp_lagged,
            lag(is_echec_comp_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_echec_comp_lagged,
            lag(is_difficulte_comp_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_difficulte_comp_lagged,
            lag(is_maitrise_comp_yearly, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_maitrise_comp_lagged
        from yearly

    )
    -- join between the results and the lagged success / failure status
    ,
    _join as (
        select
            -- Attributes 
            base.fiche,
            base.id_eco,
            ordre_ens,
            eco,
            nom_ecole,
            population,
            grp_rep,
            class,
            dist,
            base.annee,
            niveau_scolaire,
            code_matiere,
            discipline,
            groupe_matiere,
            groupe_matiere_actu,
            semestrialisation,
            promotion_matiere,
            base.description_matiere,
            etat,
            niveau_res,
            base.no_comp,
            res_num_som,
            res_num_comp,
            -- Current and lagged stauts 
            is_reussite_mat,
            is_reussite_mat_lagged,
            is_echec_mat,
            is_echec_mat_lagged,
            is_difficulte_mat,
            is_difficulte_mat_lagged,
            is_maitrise_mat,
            is_maitrise_mat_lagged,
            is_reussite_comp,
            is_reussite_comp_lagged,
            is_echec_comp,
            is_echec_comp_lagged,
            is_difficulte_comp,
            is_difficulte_comp_lagged,
            is_maitrise_comp,
            is_maitrise_comp_lagged
        from base
        left join
            lagged as l
            on base.fiche = l.fiche
            and base.id_eco = l.id_eco
            and base.annee = l.annee
            and base.description_matiere = l.description_matiere
            and base.no_comp = l.no_comp

    -- Add the yearly status
    ),
    yearly_status as (
        select
            -- Attributes 
            fiche,
            id_eco,
            ordre_ens,
            eco,
            nom_ecole,
            population,
            grp_rep,
            class,
            dist,
            annee,
            niveau_scolaire,
            semestrialisation,
            promotion_matiere,
            code_matiere,
            discipline,
            groupe_matiere,
            groupe_matiere_actu,
            description_matiere,
            etat,
            no_comp,
            niveau_res,
            res_num_som,
            res_num_comp,
            -- Status
            case
                when
                    (ordre_ens = 3 and is_echec_comp = 1)
                    or (ordre_ens = 4 and is_echec_mat = 1)
                then 1
                else 0
            end as is_echec_current_y,
            case
                when
                    (ordre_ens = 3 and is_difficulte_comp = 1)
                    or (ordre_ens = 4 and is_difficulte_mat = 1)
                then 1
                else 0
            end as is_diff_current_y,
            case
                when
                    (ordre_ens = 3 and is_maitrise_comp = 1)
                    or (ordre_ens = 4 and is_maitrise_mat = 1)
                then 1
                else 0
            end as is_maitrise_current_y,
            -- previous
            case
                when
                    (ordre_ens = 3 and is_echec_comp_lagged = 1)
                    or (ordre_ens = 4 and is_echec_mat_lagged = 1)
                then 1
                else 0
            end as is_echec_previous_y,
            case
                when
                    (ordre_ens = 3 and is_difficulte_comp_lagged = 1)
                    or (ordre_ens = 4 and is_difficulte_mat_lagged = 1)
                then 1
                else 0
            end as is_diff_previous_y,
            case
                when
                    (ordre_ens = 3 and is_maitrise_comp_lagged = 1)
                    or (ordre_ens = 4 and is_maitrise_mat_lagged = 1)
                then 1
                else 0
            end as is_maitrise_previous_y
        from _join

    -- Squeeze the yearly dimension to only keep the current year for filtering   
    -- IF we want to keep the year as a filter, we could juste remove this step
    ),
    squeezed as (
        select
            fiche,
            id_eco,
            ordre_ens,
            eco,
            nom_ecole,
            population,
            grp_rep,
            class,
            dist,
            niveau_scolaire,
            semestrialisation,
            promotion_matiere,
            annee,
            code_matiere,
            discipline,
            groupe_matiere,
            groupe_matiere_actu,
            description_matiere,
            etat,
            niveau_res,
            no_comp,
            res_num_som,
            res_num_comp,
            -- squeeze the year : the row attributes become students attributes
            max(
                case
                    when {{ core_dashboards_store.get_current_year() }} = annee
                    then is_echec_current_y
                    else null
                end
            ) over (partition by fiche, no_comp, description_matiere)
            as is_echec_current_y,
            max(
                case
                    when {{ core_dashboards_store.get_current_year() }} = annee
                    then is_diff_current_y
                    else null
                end
            ) over (partition by fiche, no_comp, description_matiere)
            as is_diff_current_y,
            max(
                case
                    when {{ core_dashboards_store.get_current_year() }} = annee
                    then is_echec_previous_y
                    else null
                end
            ) over (partition by fiche, no_comp, description_matiere)
            as is_echec_previous_y,
            max(
                case
                    when {{ core_dashboards_store.get_current_year() }} = annee
                    then is_diff_previous_y
                    else null
                end
            ) over (partition by fiche, no_comp, description_matiere)
            as is_diff_previous_y,
            max(
                case
                    when {{ core_dashboards_store.get_current_year() }} = annee
                    then is_maitrise_current_y
                    else null
                end
            ) over (partition by fiche, no_comp, description_matiere)
            as is_maitrise_current_y,
            max(
                case
                    when {{ core_dashboards_store.get_current_year() }} = annee
                    then is_maitrise_previous_y
                    else null
                end
            ) over (partition by fiche, no_comp, description_matiere)
            as is_maitrise_previous_y
        from yearly_status
    )

-- add friendly dimensions
select
    sq.id_eco,
    sq.annee,
    sq.fiche,
    sq.eco,
    sq.nom_ecole,
    el.nom_prenom_fiche,
    sq.population,
    sq.ordre_ens,
    sq.code_matiere,
    discipline,
    sq.groupe_matiere,
    groupe_matiere_actu,
    CASE WHEN Semestrialisation = 1 THEN 'Oui' ELSE 'Non' END AS is_semestrialisation,
    CASE WHEN Promotion_matiere = 1 THEN 'Oui' ELSE 'Non' END AS is_promotion_matiere,
    sq.etat,
    sq.description_matiere,
    res_num_som,
    sq.niveau_scolaire,
    sq.grp_rep,
    sq.class,
    sq.dist,
    sq.niveau_res,
    sq.no_comp,
    res_num_comp,
    descr_comp.description_abreg as description_competence_abreg,
    case
        when is_echec_current_y = 1 then 'Oui' else 'Non'
    end as is_echec_course_current,
    case when is_diff_current_y = 1 then 'Oui' else 'Non' end as is_diff_course_current,
    case
        when is_echec_previous_y = 1 then 'Oui' else 'Non'
    end as is_echec_course_previous,
    case
        when is_diff_previous_y = 1 then 'Oui' else 'Non'
    end as is_diff_course_previous,
    case
        when is_maitrise_current_y = 1 then 'Oui' else 'Non'
    end as is_maitrise_course_current,
    case
        when is_maitrise_previous_y = 1 then 'Oui' else 'Non'
    end as is_maitrise_course_previous
from squeezed as sq
inner join
    {{ ref("stg_descr_mat") }} as descr_mat
    on sq.code_matiere = descr_mat.mat
    and sq.id_eco = descr_mat.id_eco
inner join {{ ref("dim_eleve") }} as el on sq.fiche = el.fiche
inner join
    {{ ref("stg_descr_comp") }} as descr_comp
    on sq.code_matiere = descr_comp.mat
    and sq.no_comp = descr_comp.obj_01
