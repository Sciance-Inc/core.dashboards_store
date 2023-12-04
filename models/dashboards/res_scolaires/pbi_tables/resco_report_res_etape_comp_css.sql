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
{{
    config(
        alias="report_res_etape_comp_css",
    )
}}

with
    data as (
        select
            y_stud.population,
            eta_comp.annee,
            y_stud.genre,
            y_stud.plan_interv_ehdaa,
            eta_comp.mat,
            eta_comp.no_comp,
            eta_comp.etape,
            eta_comp.res_etape_num,
            eta_comp.ind_reussite
        from {{ ref("fact_resultat_etape_competence") }} as eta_comp
        inner join
            {{ ref("fact_yearly_student") }} as y_stud
            on eta_comp.fiche = y_stud.fiche
            and eta_comp.id_eco = y_stud.id_eco
        inner join
            {{ ref("resco_dim_matiere") }} as dim on dim.cod_matiere = eta_comp.mat  -- Only keep the tracked courses
        where
            y_stud.annee
            between {{ get_current_year() }} - 4 and {{ get_current_year() }}
            and eta_comp.res_etape_num is not null
            and eta_comp.etape != 'EX'
            and y_stud.genre != 'X'  -- Non binaire
            and eta_comp.ind_reprise = 0
    ),

    cal as (
        select
            *,
            case when ind_reussite = 'E' then 1. end as tx_echec,
            case when ind_reussite = 'R' then 1. end as tx_reussite,
            case
                when
                    res_etape_num > 59
                    and res_etape_num
                    < {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1.
                else 0.
            end as tx_risque,
            case
                when
                    res_etape_num
                    >= {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1.
                else 0.
            end as tx_maitrise
        from data
    ),

    agg as (
        select
            coalesce(population, 'Tout') as population,
            annee,
            mat,
            coalesce(genre, 'Tout') as genre,
            coalesce(plan_interv_ehdaa, 'Tout') as plan_interv_ehdaa,
            no_comp,
            etape,
            count(res_etape_num) as n_obs,
            avg(tx_reussite) as n_reussite,
            avg(tx_risque) as n_risque,
            avg(tx_echec) as n_echec,
            avg(tx_maitrise) as n_maitrise,
            avg(try_cast(res_etape_num as decimal(5, 2))) as resultat_avg
        from cal
        group by annee, mat, no_comp, etape, cube (genre, population, plan_interv_ehdaa)

    -- Add the statistis
    ),
    totaux as (
        select
            population,
            annee,
            mat,
            genre,
            plan_interv_ehdaa,
            no_comp,
            etape,
            n_obs,
            n_reussite,
            n_echec,
            n_risque,
            n_maitrise,
            resultat_avg
        from agg
    ),

    stats as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "population",
                        "annee",
                        "totaux.mat",
                        "totaux.no_comp",
                        "etape",
                        "genre",
                        "plan_interv_ehdaa",
                    ]
                )
            }} as primary_key,
            population,
            annee,
            totaux.mat,
            dim.des_matiere,
            totaux.no_comp,
            descr_comp.description,
            etape,
            genre,
            plan_interv_ehdaa,
            n_obs,
            resultat_avg,
            n_reussite,
            n_reussite / n_obs as percent_of_success,
            n_echec,
            n_echec / n_obs as percent_of_echec,
            n_risque,
            n_risque / n_obs as percent_of_risque,
            n_maitrise,
            n_maitrise / n_obs as percent_of_maitrise
        from totaux
        left join
            {{ ref("stg_descr_comp") }} as descr_comp
            on totaux.mat = descr_comp.mat
            and totaux.no_comp = descr_comp.obj_01
        left join {{ ref("resco_dim_matiere") }} as dim on dim.cod_matiere = totaux.mat
    )
select
    -- Dimensions
    primary_key,
    population,
    annee,
    plan_interv_ehdaa,
    mat,
    des_matiere,
    genre,
    no_comp,
    etape,
    description,
    -- Metrics
    n_obs,
    resultat_avg,
    n_reussite,
    percent_of_success,
    n_echec,
    percent_of_echec,
    n_risque,
    percent_of_risque,
    n_maitrise,
    percent_of_maitrise
from stats
