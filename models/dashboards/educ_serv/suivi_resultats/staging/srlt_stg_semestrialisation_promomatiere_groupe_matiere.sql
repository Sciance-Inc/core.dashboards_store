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
{{ config(alias="stg_semestrialisation_promomatiere_groupe_matiere") }}

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
            case
                when charindex(' ', description_matiere) > 0
                then
                    substring(
                        description_matiere, 1, charindex(' ', description_matiere) - 1
                    )
                else description_matiere
            end as discipline,
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

    /* 
   aggregate by fiche, annee, famille_matiere
   - cnt_levels_by_discipline : number of distinct levels for the same "discipline"
 */
    -- aggregate by fiche, annee, famille_matiere
    ),
    matiere_agg as (
        select
            fiche,
            annee,
            discipline,
            count(distinct niveau_res) as cnt_levels_by_discipline,
            min(niveau_res) as niveau_res
        from res_history rh
        where annee = {{ core_dashboards_store.get_current_year() }}
        group by fiche, annee, discipline
    /*
    Flags at the level (fiche, annee)
   - Semestrialisation : ≥1 discipline with ≥2 niveau_res
   - Promotion_matiere : ≥2 discipline and ≥2 niveau_res 
    */
    ),
    eleve_annee_flags as (
        select
            fiche,
            annee,
            max(
                case when cnt_levels_by_discipline >= 2 then 1 else 0 end
            ) as semestrialisation,
            count(distinct discipline) as nb_familles,
            count(distinct niveau_res) as nb_niveaux_distincts
        from matiere_agg
        group by fiche, annee
    ),
    flags as (
        select
            fiche,
            annee,
            semestrialisation,
            case
                when nb_familles >= 2 and nb_niveaux_distincts >= 2 then 1 else 0
            end as promotion_matiere
        from eleve_annee_flags
    )
select
    rh.fiche,
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
    rh.annee,
    code_matiere,
    groupe_matiere,
    discipline,
    {# case
        when max(rh.annee) over (partition by rh.fiche, discipline) = 2025
        then
            first_value(groupe_matiere) over (
                partition by rh.fiche, discipline
                order by rh.annee desc
                rows between unbounded preceding and unbounded following
            )
        else null
    end as groupe_matiere_actu, #}
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
from res_history rh
left join flags on flags.fiche = rh.fiche  -- AND flags.annee = rh.annee
