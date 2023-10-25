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
        alias="report_res_comp_etape_css",
    )
}}

with
    data as (
        select
            y_student.code_perm,
            y_student.population,
            y_student.annee,
            y_student.ordre_ens,
            y_student.genre,
            y_student.plan_interv_ehdaa,
            y_student.niveau_scolaire,
            etape.mat,
            -- etape.grp,
            etape.id_obj_mat,
            etape.no_comp,
            descr_etape.descr,
            -- etape.etat,
            etape.etape,
            -- etape.reprise,
            etape.res_etape_num
        from {{ ref("fact_yearly_student") }} as y_student
        left join
            {{ ref("fact_res_etape_comp") }} as etape
            on y_student.fiche = etape.fiche
            and y_student.id_eco = etape.id_eco
        left join
            {{ ref("stg_descr_comp_etape") }} as descr_etape
            on etape.id_obj_mat = descr_etape.id_obj_mat
            and etape.mat = descr_etape.mat
        inner join {{ ref("resco_dim_matiere") }} as dim on dim.cod_matiere = etape.mat  -- Only keep the tracked courses
        where
            y_student.annee
            between {{ get_current_year() }} - 4 and {{ get_current_year() }}
            and etape.res_etape_num is not null
    ),

    cal as (
        select
            *,
            case when res_etape_num < 60 then 1 else 0 end as tx_echec,
            case when res_etape_num > 59 then 1 else 0 end as tx_reussite,
            case
                when
                    res_etape_num > 59
                    and res_etape_num
                    < {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1
                else 0
            end as tx_risque,
            case
                when
                    res_etape_num
                    >= {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1
                else 0
            end as tx_maitrise
        from data
    ),

    agg as (
        select
            population,
            annee,
            ordre_ens,
            mat,
            genre,
            plan_interv_ehdaa,
            no_comp,
            descr,
            etape,
            count(res_etape_num) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    no_comp,
                    descr,
                    etape,
                    genre,
                    plan_interv_ehdaa
            ) as n_obs_f,
            count(res_etape_num) over (
                partition by annee, mat, no_comp, etape, population
            ) as n_obs_g,
            count(res_etape_num) over (
                partition by annee, mat, no_comp, etape, population, plan_interv_ehdaa
            ) as n_obs_pi,
            count(res_etape_num) over (
                partition by annee, mat, no_comp, etape, population, genre
            ) as n_obs_gre,
            sum(try_cast(tx_reussite as float)) over (
                partition by annee, mat, no_comp, etape, population
            ) as n_reussite_g,
            sum(try_cast(tx_reussite as float)) over (
                partition by annee, mat, no_comp, etape, population, plan_interv_ehdaa
            ) as n_reussite_pi,
            sum(try_cast(tx_reussite as float)) over (
                partition by annee, mat, no_comp, etape, population, genre
            ) as n_reussite_gre,
            sum(try_cast(tx_reussite as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    no_comp,
                    descr,
                    etape,
                    genre,
                    plan_interv_ehdaa
            ) as n_reussite_f,
            sum(try_cast(tx_risque as float)) over (
                partition by annee, mat, no_comp, etape, population
            ) as n_risque_g,
            sum(try_cast(tx_risque as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    no_comp,
                    descr,
                    etape,
                    genre,
                    plan_interv_ehdaa
            ) as n_risque_f,
            sum(try_cast(tx_echec as float)) over (
                partition by annee, mat, no_comp, etape, population
            ) as n_echec_g,
            sum(try_cast(tx_echec as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    no_comp,
                    descr,
                    etape,
                    genre,
                    plan_interv_ehdaa
            ) as n_echec_f,
            sum(try_cast(tx_maitrise as float)) over (
                partition by annee, mat, no_comp, etape, population
            ) as n_maitrise_g,
            sum(try_cast(tx_maitrise as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    no_comp,
                    descr,
                    etape,
                    genre,
                    plan_interv_ehdaa
            ) as n_maitrise_f,
            avg(try_cast(res_etape_num as decimal(5, 2))) over (
                partition by annee, mat, no_comp, etape, population
            ) as resultat_avg_g,
            avg(try_cast(res_etape_num as decimal(5, 2))) over (
                partition by annee, mat, no_comp, etape, population, genre
            ) as resultat_avg_gre,
            avg(try_cast(res_etape_num as decimal(5, 2))) over (
                partition by annee, mat, no_comp, etape, population, plan_interv_ehdaa
            ) as resultat_avg_pi,
            avg(try_cast(res_etape_num as decimal(5, 2))) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    no_comp,
                    descr,
                    etape,
                    genre,
                    plan_interv_ehdaa
            ) as resultat_avg_f
        from cal
    -- Add the statistis
    ),
    totaux as (
        select
            population,
            annee,
            ordre_ens,
            mat,
            genre,
            plan_interv_ehdaa,
            no_comp,
            descr,
            etape,
            max(n_obs_f) as n_obs_f,
            max(n_obs_g) as n_obs_g,
            max(n_obs_gre) as n_obs_gre,
            max(n_obs_pi) as n_obs_pi,
            max(n_reussite_f) as n_reussite_f,
            max(n_reussite_g) as n_reussite_g,
            max(n_reussite_gre) as n_reussite_gre,
            max(n_reussite_pi) as n_reussite_pi,
            max(n_risque_f) as n_risque_f,
            max(n_risque_g) as n_risque_g,
            max(n_echec_f) as n_echec_f,
            max(n_echec_g) as n_echec_g,
            max(n_maitrise_f) as n_maitrise_f,
            max(n_maitrise_g) as n_maitrise_g,
            max(resultat_avg_f) as resultat_avg_f,
            max(resultat_avg_g) as resultat_avg_g,
            max(resultat_avg_gre) as resultat_avg_gre,
            max(resultat_avg_pi) as resultat_avg_pi
        from agg
        group by
            population,
            annee,
            ordre_ens,
            mat,
            no_comp,
            descr,
            etape,
            genre,
            plan_interv_ehdaa
    ),

    stats as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "population",
                        "annee",
                        "mat",
                        "no_comp",
                        "etape",
                        "genre",
                        "plan_interv_ehdaa",
                        "descr",
                    ]
                )
            }} as id_mat_year,
            population,
            annee,
            ordre_ens,
            mat,
            no_comp,
            descr,
            etape,
            genre,
            plan_interv_ehdaa,
            n_obs_f,
            n_obs_g,
            n_obs_gre,
            n_obs_pi,
            resultat_avg_f,
            resultat_avg_g,
            resultat_avg_gre,
            resultat_avg_pi,
            n_reussite_f,
            n_reussite_f / n_obs_f as percent_of_success_f,
            n_reussite_g,
            n_reussite_g / n_obs_g as percent_of_success_g,
            n_reussite_gre,
            n_reussite_gre / n_obs_gre as percent_of_success_gre,
            n_reussite_pi,
            n_reussite_pi / n_obs_pi as percent_of_success_pi,
            n_echec_f,
            n_echec_f / n_obs_f as percent_of_echec_f,
            n_echec_g,
            n_echec_g / n_obs_g as percent_of_echec_g,
            n_risque_f,
            n_risque_f / n_obs_f as percent_of_risque_f,
            n_risque_g,
            n_risque_g / n_obs_g as percent_of_risque_g,
            n_maitrise_f,
            n_maitrise_f / n_obs_f as percent_of_maitrise_f,
            n_maitrise_g,
            n_maitrise_g / n_obs_g as percent_of_maitrise_g
        from totaux
    )
select
    -- Dimensions
    id_mat_year,
    population,
    annee,
    ordre_ens,
    plan_interv_ehdaa,
    mat,
    genre,
    no_comp,
    descr,
    etape,
    -- Metrics
    n_obs_f,
    n_obs_g,
    n_obs_gre,
    n_obs_pi,
    resultat_avg_f,
    resultat_avg_g,
    resultat_avg_gre,
    resultat_avg_pi,
    n_reussite_f,
    percent_of_success_f,
    n_reussite_g,
    percent_of_success_g,
    n_reussite_gre,
    percent_of_success_gre,
    n_reussite_pi,
    percent_of_success_pi,
    n_echec_f,
    percent_of_echec_f,
    n_echec_g,
    percent_of_echec_g,
    n_risque_f,
    percent_of_risque_f,
    n_risque_g,
    percent_of_risque_g,
    n_maitrise_f,
    percent_of_maitrise_f,
    n_maitrise_g,
    percent_of_maitrise_g
from stats
