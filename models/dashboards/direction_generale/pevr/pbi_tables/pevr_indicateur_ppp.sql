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
{{ config(alias="indicateur_ppp") }}

with
    src as (
        select
            '1.3.4.11' as id_indicateur_meq,
            sch.annee_scolaire,
            sch.annee,
            case
                when sch.school_friendly_name is null
                then '-'
                else sch.school_friendly_name
            end as school_friendly_name,
            case when ele.genre is null then '-' else ele.genre end as genre,
            case
                when y_stud.plan_interv_ehdaa is null
                then '-'
                else y_stud.plan_interv_ehdaa
            end as plan_interv_ehdaa,
            case
                when y_stud.population is null then '-' else y_stud.population
            end as population,
            case
                when y_stud.class is null then '-' else y_stud.class
            end as classification,
            case when y_stud.dist is null then '-' else y_stud.dist end as distribution,
            case
                when y_stud.grp_rep is null then '-' else y_stud.grp_rep
            end as groupe_repere,
            case when y_stud.is_ppp = 1 then 1. else 0. end as is_ppp
        from {{ ref("fact_yearly_student") }} y_stud
        inner join {{ ref("dim_eleve") }} as ele on y_stud.fiche = ele.fiche
        inner join {{ ref("dim_mapper_schools") }} as sch on y_stud.id_eco = sch.id_eco
        where
            ordre_ens = 4
            and sch.annee
            between {{ core_dashboards_store.get_current_year() }}
            - 3 and {{ core_dashboards_store.get_current_year() }}

    ),

    ind_pevr as (
        select
            id_indicateur_meq,
            is_ppp,
            annee_scolaire,
            school_friendly_name,
            genre,
            plan_interv_ehdaa,
            population,
            classification,
            distribution,
            groupe_repere
        from src
    ),

    ppp as (
        select
            annee_scolaire,
            school_friendly_name,
            genre,
            plan_interv_ehdaa,
            population,
            classification,
            distribution,
            groupe_repere,
            id_indicateur_meq,
            sum(is_ppp) as nb_ppp,
            avg(is_ppp) as taux_ppp
        from ind_pevr
        group by
            annee_scolaire,
            id_indicateur_meq, cube (
                school_friendly_name,
                genre,
                plan_interv_ehdaa,
                population,
                classification,
                distribution,
                groupe_repere
            )
    ),

    _coalesce as (
        select
            id_indicateur_meq,
            annee_scolaire,
            coalesce(school_friendly_name, 'CSS') as ecole,
            coalesce(genre, 'Tout') as genre,
            coalesce(plan_interv_ehdaa, 'Tout') as plan_interv_ehdaa,
            coalesce(population, 'Tout') as population,
            coalesce(classification, 'Tout') as classification,
            coalesce(distribution, 'Tout') as distribution,
            coalesce(groupe_repere, 'Tout') as groupe_repere,
            nb_ppp,
            taux_ppp
        from ppp
    ),

    id_filtre as (
        select
            ind.objectif,
            ind.id_indicateur_meq,
            ind.id_indicateur_css,
            ind.description_indicateur,
            cib.annee_scolaire,
            nb_ppp,
            taux_ppp,
            cib.cible,
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "ecole",
                        "cib.annee_scolaire",
                        "plan_interv_ehdaa",
                        "genre",
                        "population",
                        "classification",
                        "distribution",
                        "groupe_repere",
                    ]
                )
            }} as id_filtre
        from {{ ref("pevr_dim_cibles_annuelles") }} cib
        left join
            {{ ref("pevr_dim_indicateurs") }} as ind
            on ind.id_indicateur_meq = cib.id_indicateur_meq
        left join
            _coalesce as id
            on id.id_indicateur_meq = cib.id_indicateur_meq
            and id.annee_scolaire = cib.annee_scolaire

    ),
    val_depart as (
        select
            objectif,
            coalesce(id_indicateur_css, id_indicateur_meq) id_indicateur,
            description_indicateur,
            case
                when annee_scolaire = '2022 - 2023'
                then 'Valeur de départ'
                else annee_scolaire
            end as annee_scolaire,
            taux_ppp,
            nb_ppp,
            cible,
            case
                when taux_ppp is null
                then concat('(', cast(cible * 100 as decimal(5, 1)), '%)')
                else
                    concat(
                        cast(taux_ppp * 100 as decimal(5, 1)),
                        '% (',
                        cast(cible * 100 as decimal(5, 1)),
                        '%)'
                    )
            end as taux_cible,
            id_filtre
        from id_filtre
    )

select
    objectif,
    id_indicateur,
    description_indicateur,
    'GPI' as source,
    annee_scolaire,
    taux_ppp,
    nb_ppp,
    cible,
    case
        when annee_scolaire = 'Valeur de départ'
        then concat(cast(taux_ppp * 100 as decimal(5, 1)), '%')
        else taux_cible
    end as taux_cible,
    id_filtre
from val_depart
