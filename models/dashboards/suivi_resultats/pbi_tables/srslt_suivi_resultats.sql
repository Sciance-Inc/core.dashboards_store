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
{{ config(alias="suivi_resultats") }}

with
    perim as (
        select fiche, id_eco, ordre_ens
        from {{ ref("fact_yearly_student") }}
        where annee = {{ store.get_current_year() }}
    ),
    src as (
        select
            el.id_eco,
            el.fiche,
            mat.annee,
            el.ordre_ens,
            mat.code_matiere,
            mat.groupe_matiere,
            mat.etat,
            dim.des_matiere,
            res_num_som,
            mat.ind_reussite as ind_reussite_mat,
            no_comp,
            res_num_comp,
            comp.ind_reussite as ind_reussite_comp
        from perim as el
        left join
            {{ ref("fact_resultat_bilan_matiere") }} as mat on mat.fiche = el.fiche
        -- and mat.id_eco = el.id_eco
        left join
            {{ ref("fact_resultat_bilan_competence") }} as comp
            on mat.fiche = comp.fiche
            and mat.code_matiere = comp.code_matiere
            and mat.groupe_matiere = comp.groupe_matiere
            and mat.id_eco = comp.id_eco
        inner join
            {{ ref("srslt_dim_matieres_suivi") }} as dim
            on dim.code_matiere = mat.code_matiere  -- Only keep the tracked courses           
        where
            mat.annee
            between {{ store.get_current_year() }}
            - 4 and {{ store.get_current_year() }}
            and mat.etat != 0
            and comp.etat != 0
            and mat.ind_reprise = 0
            and comp.ind_reprise = 0

    -- ajouter le flag years
    ),
    res_y as (
        select
            id_eco,
            fiche,
            annee,
            ordre_ens,
            null as code_matiere,
            null as groupe_matiere,
            null as etat,
            null as des_matiere,
            null as res_num_som,
            null as ind_reussite_mat,
            null as no_comp,
            null as res_num_comp,
            null as ind_reussite_comp
        from src
        where annee = {{ store.get_current_year() }}
    ),
    merg as (
        select *
        from src
        union
        select *
        from res_y

    ),
    tag as (
        select
            id_eco,
            annee,
            fiche,
            ordre_ens,
            code_matiere,
            etat,
            groupe_matiere,
            des_matiere,
            res_num_som,
            ind_reussite_mat,
            no_comp,
            res_num_comp,
            ind_reussite_comp,
            case
                when annee = {{ store.get_current_year() }} then 1 else 0
            end as is_current_year,
            case
                when annee = {{ store.get_current_year() }} - 1 then 1 else 0
            end as is_previous_year
        from merg
    -- ajouter le flag difficulté
    ),
    dif as (
        select
            id_eco,
            annee,
            fiche,
            ordre_ens,
            code_matiere,
            groupe_matiere,
            etat,
            des_matiere,
            res_num_som,
            ind_reussite_mat,
            no_comp,
            res_num_comp,
            ind_reussite_comp,
            is_current_year,
            is_previous_year,
            case
                when
                    (ordre_ens = 3 and is_current_year = 1 and res_num_comp < 60)
                    or (ordre_ens = 4 and is_current_year = 1 and res_num_som < 60)
                then 1
                else 0
            end as is_echec_current_y,
            case
                when
                    (
                        ordre_ens = 3
                        and is_current_year = 1
                        and res_num_comp >= 60
                        and res_num_comp < 70
                    )
                    or (
                        ordre_ens = 4
                        and is_current_year = 1
                        and res_num_som >= 60
                        and res_num_som < 70
                    )
                then 1
                else 0
            end as is_diff_current_y,
            case
                when
                    (ordre_ens = 3 and is_previous_year = 1 and res_num_comp < 60)
                    or (ordre_ens = 4 and is_previous_year = 1 and res_num_som < 60)
                then 1
                else 0
            end as is_echec_previous_y,
            case
                when
                    (
                        ordre_ens = 3
                        and is_previous_year = 1
                        and res_num_comp >= 60
                        and res_num_comp < 70
                    )
                    or (
                        ordre_ens = 4
                        and is_previous_year = 1
                        and res_num_som >= 60
                        and res_num_som < 70
                    )
                then 1
                else 0
            end as is_diff_previous_y,
            case
                when
                    (ordre_ens = 3 and is_current_year = 1 and res_num_comp >= 70)
                    or (ordre_ens = 4 and is_current_year = 1 and res_num_som >= 70)
                then 1
                else 0
            end as is_maitrise_current_y,
            case
                when
                    (ordre_ens = 3 and is_previous_year = 1 and res_num_comp >= 70)
                    or (ordre_ens = 4 and is_previous_year = 1 and res_num_som >= 70)
                then 1
                else 0
            end as is_maitrise_previous_y,
            case
                when
                    code_matiere like 'ANG%'
                    or code_matiere like 'FRA%'
                    or code_matiere like 'MAT%'
                then 'PRI' + ' ' + substring(code_matiere, 4, 1)
                else 'SEC' + ' ' + substring(code_matiere, 4, 1)
            end as niveau_res
        from tag
    ),
    step1 as (
        select
            id_eco,
            annee,
            fiche,
            ordre_ens,
            code_matiere,
            groupe_matiere,
            etat,
            des_matiere,
            niveau_res,
            res_num_som,
            ind_reussite_mat,
            no_comp,
            res_num_comp,
            ind_reussite_comp,
            is_current_year,
            is_previous_year,
            max(is_echec_current_y) over (
                partition by fiche, des_matiere
            ) as is_echec_course_current,
            max(is_diff_current_y) over (
                partition by fiche, des_matiere
            ) as is_diff_course_current,
            max(is_echec_previous_y) over (
                partition by fiche, des_matiere
            ) as is_echec_course_previous,
            max(is_diff_previous_y) over (
                partition by fiche, des_matiere
            ) as is_diff_course_previous,
            max(is_maitrise_current_y) over (
                partition by fiche, des_matiere
            ) as is_maitrise_course_current,
            max(is_maitrise_previous_y) over (
                partition by fiche, des_matiere
            ) as is_maitrise_course_previous
        from dif
    )
select
    step1.id_eco,
    step1.annee,
    step1.fiche,
    el.eco,
    el.nom_ecole,
    el.nom_prenom_fiche,
    el.population,
    step1.ordre_ens,
    step1.code_matiere,
    groupe_matiere,
    case
        when des_matiere like 'Fr%'
        then 'Français'
        when des_matiere like 'Math%'
        then 'Mathématique'
        when des_matiere like 'Sc%'
        then 'Science'
        when des_matiere like 'Hi%'
        then 'Histoire'
        else 'Anglais'
    end as discipline,
    etat,
    step1.des_matiere,
    step1.res_num_som,
    niveau_scolaire,
    grp_rep,
    dist,
    niveau_res,
    step1.ind_reussite_mat,
    step1.no_comp,
    descr_comp.descr_abreg,
    step1.res_num_comp,
    step1.ind_reussite_comp,
    step1.is_current_year,
    step1.is_previous_year,
    case
        when is_echec_course_current = 1 then 'Oui' else 'Non'
    end as is_echec_course_current,
    case
        when is_diff_course_current = 1 then 'Oui' else 'Non'
    end as is_diff_course_current,
    case
        when is_echec_course_previous = 1 then 'Oui' else 'Non'
    end as is_echec_course_previous,
    case
        when is_diff_course_previous = 1 then 'Oui' else 'Non'
    end as is_diff_course_previous,
    case
        when is_maitrise_course_current = 1 then 'Oui' else 'Non'
    end as is_maitrise_course_current,
    case
        when is_maitrise_course_previous = 1 then 'Oui' else 'Non'
    end as is_maitrise_course_previous

from step1
inner join
    {{ ref("fact_yearly_student") }} as el
    on step1.fiche = el.fiche
    and step1.id_eco = el.id_eco
left join
    {{ ref("stg_descr_comp") }} as descr_comp
    on step1.code_matiere = descr_comp.mat
    and step1.no_comp = descr_comp.obj_01
