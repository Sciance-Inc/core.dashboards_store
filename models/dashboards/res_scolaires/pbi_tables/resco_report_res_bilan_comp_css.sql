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
        alias="report_res_bilan_comp_css",
    )
}}

with
    cal as (
        select
            code_perm,
            population,
            annee,
            ordre_ens,
            mat,
            des_matiere,
            plan_interv_ehdaa,
            genre,
            no_competence,
            descr,
            case when res_num_comp < 60 then 1 else 0 end as tx_echec,
            case when res_num_comp > 59 then 1 else 0 end as tx_reussite,
            case
                when
                    res_num_comp > 59
                    and res_num_comp
                    < {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1
                else 0
            end as tx_risque,
            case
                when
                    res_num_comp
                    >= {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1
                else 0
            end as tx_maitrise,
            res_num_comp
        from {{ ref("fact_res_bilan_comp") }}
        inner join {{ ref("resco_dim_matiere") }} as dim on dim.cod_matiere = mat  -- Only keep the tracked courses
        where annee between {{ get_current_year() }} - 4 and {{ get_current_year() }}
    ),
    agg as (
        select
            population,
            annee,
            ordre_ens,
            mat,
            des_matiere,
            genre,
            plan_interv_ehdaa,
            no_competence,
            descr,
            count(res_num_comp) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    des_matiere,
                    no_competence,
                    descr,
                    genre,
                    plan_interv_ehdaa
            ) as n_obs_f,
            count(res_num_comp) over (
                partition by annee, mat, no_competence, population
            ) as n_obs_g,
            count(res_num_comp) over (
                partition by annee, mat, no_competence, population, plan_interv_ehdaa
            ) as n_obs_pi,
            count(res_num_comp) over (
                partition by annee, mat, no_competence, population, genre
            ) as n_obs_gre,
            sum(try_cast(tx_reussite as float)) over (
                partition by annee, mat, no_competence, population
            ) as n_reussite_g,
            sum(try_cast(tx_reussite as float)) over (
                partition by annee, mat, no_competence, population, plan_interv_ehdaa
            ) as n_reussite_pi,
            sum(try_cast(tx_reussite as float)) over (
                partition by annee, mat, no_competence, population, genre
            ) as n_reussite_gre,
            sum(try_cast(tx_reussite as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    des_matiere,
                    no_competence,
                    descr,
                    genre,
                    plan_interv_ehdaa
            ) as n_reussite_f,
            sum(try_cast(tx_risque as float)) over (
                partition by annee, mat, no_competence, population
            ) as n_risque_g,
            sum(try_cast(tx_risque as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    des_matiere,
                    no_competence,
                    descr,
                    genre,
                    plan_interv_ehdaa
            ) as n_risque_f,
            sum(try_cast(tx_echec as float)) over (
                partition by annee, mat, no_competence, population
            ) as n_echec_g,
            sum(try_cast(tx_echec as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    des_matiere,
                    no_competence,
                    descr,
                    genre,
                    plan_interv_ehdaa
            ) as n_echec_f,
            sum(try_cast(tx_maitrise as float)) over (
                partition by annee, mat, no_competence, population
            ) as n_maitrise_g,
            sum(try_cast(tx_maitrise as float)) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    des_matiere,
                    no_competence,
                    descr,
                    genre,
                    plan_interv_ehdaa
            ) as n_maitrise_f,
            avg(try_cast(res_num_comp as decimal(5, 2))) over (
                partition by annee, mat, no_competence, population
            ) as resultat_avg_g,
            avg(try_cast(res_num_comp as decimal(5, 2))) over (
                partition by annee, mat, no_competence, population, genre
            ) as resultat_avg_gre,
            avg(try_cast(res_num_comp as decimal(5, 2))) over (
                partition by annee, mat, no_competence, population, plan_interv_ehdaa
            ) as resultat_avg_pi,
            avg(try_cast(res_num_comp as decimal(5, 2))) over (
                partition by
                    population,
                    annee,
                    ordre_ens,
                    mat,
                    des_matiere,
                    no_competence,
                    descr,
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
            des_matiere,
            no_competence,
            descr,
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
            des_matiere,
            no_competence,
            descr,
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
                        "no_competence",
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
            des_matiere,
            no_competence,
            descr,
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
    des_matiere,
    no_competence,
    descr,
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
