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

-- Fetch the students currently enrolled in the school system
with
    base as (
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
            niveau_scolaire
        from {{ ref("fact_yearly_student") }}
        where annee = {{ core_dashboards_store.get_current_year() }}

    -- Fetch the results for the students currently enrolled 
    ),
    res_history as (
        select
            -- Attributes
            base.fiche,
            base.id_eco,
            base.ordre_ens,
            base.eco,
            base.nom_ecole,
            base.population,
            niveau_res,
            base.niveau_scolaire,
            base.grp_rep,
            base.class,
            base.dist,
            -- Matiere 
            bilan_mat.annee,
            bilan_mat.code_matiere,
            bilan_mat.groupe_matiere,
            bilan_mat.etat,
            dim.description_matiere,
            bilan_mat.res_num_som,
            bilan_mat.is_reussite as is_reussite_mat,
            bilan_mat.is_echec as is_echec_mat,
            bilan_mat.is_difficulte as is_difficulte_mat,
            bilan_mat.is_maitrise as is_maitrise_mat,
            -- Comp 
            bilan_comp.no_comp,
            bilan_comp.res_num_comp,
            bilan_comp.is_reussite as is_reussite_comp,
            bilan_comp.is_echec as is_echec_comp,
            bilan_comp.is_difficulte as is_difficulte_comp,
            bilan_comp.is_maitrise as is_maitrise_comp
        from base
        left join
            {{ ref("fact_resultat_bilan_matiere") }} as bilan_mat
            on base.fiche = bilan_mat.fiche
            and bilan_mat.annee
            between {{ core_dashboards_store.get_current_year() - 4 }}
            and {{ core_dashboards_store.get_current_year() }}
        left join
            {{ ref("fact_resultat_bilan_competence") }} as bilan_comp
            on bilan_mat.fiche = bilan_comp.fiche
            and bilan_mat.code_matiere = bilan_comp.code_matiere
            and bilan_mat.groupe_matiere = bilan_comp.groupe_matiere
            and bilan_mat.id_eco = bilan_comp.id_eco
        inner join
            {{ ref("srslt_dim_matieres_suivi") }} as dim
            on dim.code_matiere = bilan_mat.code_matiere  -- Only keep the tracked courses   
        where
            bilan_mat.etat != 0
            and bilan_comp.etat != 0
            and bilan_mat.is_reprise = 0
            and bilan_comp.is_reprise = 0

    -- Compute the lagged success / failure status
    ),
    lagged as (
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
            code_matiere,
            groupe_matiere,
            description_matiere,
            etat,
            niveau_res,
            no_comp,
            res_num_som,
            res_num_comp,
            -- Current and lagged stauts 
            is_reussite_mat,
            lag(is_reussite_mat, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_reussite_mat_lagged,
            is_echec_mat,
            lag(is_echec_mat, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_echec_mat_lagged,
            is_difficulte_mat,
            lag(is_difficulte_mat, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_difficulte_mat_lagged,
            is_maitrise_mat,
            lag(is_maitrise_mat, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_maitrise_mat_lagged,
            is_reussite_comp,
            lag(is_reussite_comp, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_reussite_comp_lagged,
            is_echec_comp,
            lag(is_echec_comp, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_echec_comp_lagged,
            is_difficulte_comp,
            lag(is_difficulte_comp, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_difficulte_comp_lagged,
            is_maitrise_comp,
            lag(is_maitrise_comp, 1, null) over (
                partition by fiche, no_comp, description_matiere order by annee
            ) as is_maitrise_comp_lagged
        from res_history

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
            code_matiere,
            groupe_matiere,
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
        from lagged

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
            annee,
            code_matiere,
            groupe_matiere,
            description_matiere,
            etat,
            niveau_res,
            no_comp,
            res_num_som,
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
    stt.id_eco,
    stt.annee,
    stt.fiche,
    stt.eco,
    stt.nom_ecole,
    el.nom_prenom_fiche,
    stt.population,
    stt.ordre_ens,
    stt.code_matiere,
    stt.groupe_matiere,
    descr_mat.description_abreg as discipline,
    stt.etat,
    stt.description_matiere,
    res_num_som,
    stt.niveau_scolaire,
    stt.grp_rep,
    stt.class,
    stt.dist,
    stt.niveau_res,
    stt.no_comp,
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
from yearly_status as stt
inner join {{ ref("stg_descr_mat") }} as descr_mat on stt.code_matiere = descr_mat.mat
inner join {{ ref("dim_eleve") }} as el on stt.fiche = el.fiche
inner join
    {{ ref("stg_descr_comp") }} as descr_comp
    on stt.code_matiere = descr_comp.mat
    and stt.no_comp = descr_comp.obj_01
