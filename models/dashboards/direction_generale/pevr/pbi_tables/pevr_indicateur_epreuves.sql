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
{{ config(alias="indicateur_epreuves") }}


with
    src as (
        select
            id_indicateur_meq,
            res.annee,
            sch.annee_scolaire,
            res.fiche,
            case
                when sch.school_friendly_name is null
                then '-'
                else sch.school_friendly_name
            end as school_friendly_name,
            case when el.genre is null then '-' else el.genre end as genre,
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
            ind.code_matiere,
            ind.no_competence,
            etape,
            cast(is_maitrise as decimal(2, 1)) is_maitrise
        from {{ ref("fact_resultat_etape_competence") }} as res
        left join
            {{ ref("fact_yearly_student") }} as y_stud
            on y_stud.fiche = res.fiche
            and y_stud.id_eco = res.id_eco
        inner join {{ ref("dim_mapper_schools") }} as sch on res.id_eco = sch.id_eco
        inner join {{ ref("dim_eleve") }} as el on res.fiche = el.fiche
        inner join
            {{ ref("pevr_dim_indicateurs") }} as ind
            on res.code_matiere = ind.code_matiere
            and res.no_comp = ind.no_competence
        where
            res.annee
            between {{ core_dashboards_store.get_current_year() }}
            - 3 and {{ core_dashboards_store.get_current_year() }}
            and etape = 'EX'
            and id_indicateur_meq in ('1.1.1.4', '1.1.1.5', '1.1.1.6')  -- Au cas-où qu'on utilise le champs code_matière pour d'autre indicateur
    ),

    agg as (
        select
            id_indicateur_meq,
            annee_scolaire,
            school_friendly_name,
            genre,
            plan_interv_ehdaa,
            population,
            classification,
            distribution,
            groupe_repere,
            code_matiere,
            count(fiche) nb_resultat,
            cast(avg(is_maitrise) as decimal(5, 3)) as taux_maitrise
        from src
        group by
            id_indicateur_meq,
            annee_scolaire,
            code_matiere, cube (
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
            nb_resultat,
            taux_maitrise
        from agg
    ),
    id_filtre as (
        select
            ind.objectif,
            ind.id_indicateur_meq,
            ind.id_indicateur_css,
            ind.description_indicateur,
            cib.annee_scolaire,
            id.nb_resultat,
            id.taux_maitrise,  -- Possibilité d'avoir un null à cause du res_etape_num peut être nulle. A voir.
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
            nb_resultat,
            taux_maitrise,  -- Possibilité d'avoir un null à cause du res_etape_num peut être nulle. A voir.
            cible,
            case
                when taux_maitrise is null
                then concat('(', cast(cible * 100 as decimal(5, 1)), '%)')
                else
                    concat(
                        cast(taux_maitrise * 100 as decimal(5, 1)),
                        '% (',
                        cast(cible * 100 as decimal(5, 1)),
                        '%)'
                    )
            end as taux_cible,
            id_filtre
        from id_filtre as id
    )

select
    objectif,
    id_indicateur,
    description_indicateur,
    annee_scolaire,
    case
        when annee_scolaire = 'Valeur de départ'
        then 1
        when annee_scolaire = '2023 - 2024'
        then 2
        when annee_scolaire = '2024 - 2025'
        then 3
        when annee_scolaire = '2025 - 2026'
        then 4
        when annee_scolaire = '2026 - 2027'
        then 5
        else 0
    end as tri_annee,
    nb_resultat,
    taux_maitrise,  -- Possibilité d'avoir un null à cause du res_etape_num peut être nulle. A voir.
    cible,
    case
        when annee_scolaire = 'Valeur de départ'
        then concat(cast(taux_maitrise * 100 as decimal(5, 1)), '%')
        else taux_cible
    end as taux_cible,
    id_filtre
from val_depart
