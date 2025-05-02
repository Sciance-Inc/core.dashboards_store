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
{{ config(alias="filtres") }}

with
    src as (
        select
            m_school.school_friendly_name,
            m_school.annee_scolaire,
            y_stud.plan_interv_ehdaa,
            el.genre,
            y_stud.population,
            y_stud.class,
            y_stud.dist,
            y_stud.grp_rep
        from {{ ref("fact_yearly_student") }} y_stud
        inner join {{ ref("dim_eleve") }} el ON y_stud.fiche = el.fiche
        inner join {{ ref("dim_mapper_schools") }} m_school ON y_stud.id_eco = m_school.id_eco
    ),

_coalesce as (
    select
        school_friendly_name,
        annee_scolaire,
        plan_interv_ehdaa,
        genre,
        population,
        coalesce(class, '-') as class,
        coalesce(dist, '-') as dist,
        coalesce(grp_rep, '-') as grp_rep
    from src
),

_cube as (
    select
        school_friendly_name,
        annee_scolaire,
        plan_interv_ehdaa,
        genre,
        population,
        class,
        dist,
        grp_rep
    from _coalesce
    group by cube (
        school_friendly_name,
        annee_scolaire,
        plan_interv_ehdaa,
        genre,
        population,
        class,
        dist,
        grp_rep
    )
),

_coalesce_2 as (
    select
        coalesce(school_friendly_name, 'CSS') as ecole,
        coalesce(annee_scolaire, 'Tout') as annee_scolaire,
        coalesce(plan_interv_ehdaa, 'Tout') as plan_interv_ehdaa,
        coalesce(genre, 'Tout') as genre,
        coalesce(population, 'Tout') as population,
        coalesce(class, 'Tout') as classification,
        coalesce(dist, 'Tout') as distribution,
        coalesce(grp_rep, 'Tout') as groupe_repere
    from _cube
),

annee_prev as (
        select
            ecole,
            annee_scolaire,
            plan_interv_ehdaa,
            genre,
            population,
            classification,
            distribution,
            groupe_repere
        from _coalesce_2
        union
        select
            null as ecole,
            '2025 - 2026' as annee_scolaire,
            null as plan_interv_ehdaa,
            null as genre,
            null as population,
            null as classification,
            null as distribution,
            null as groupe_repere
        union
        select
            null as ecole,
            '2026 - 2027' as annee_scolaire,
            null as plan_interv_ehdaa,
            null as genre,
            null as population,
            null as classification,
            null as distribution,
            null as groupe_repere
    )

select 
    ecole,
    annee_scolaire,
    plan_interv_ehdaa,
    genre,
    population,
    classification,
    distribution,
    groupe_repere,
    {{
        dbt_utils.generate_surrogate_key(
            [
                "ecole",
                "annee_scolaire",
                "plan_interv_ehdaa",
                "genre",
                "population",
                "classification",
                "distribution",
                "groupe_repere",
            ]
        )
    }} as id_filtre
from annee_prev
