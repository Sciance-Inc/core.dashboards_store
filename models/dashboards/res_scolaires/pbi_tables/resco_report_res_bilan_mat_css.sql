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
        alias="report_res_bilan_mat_css",
    )
}}

with
    data as (
        select
            y_stud.population,
            res_bilan.annee,
            y_stud.genre,
            y_stud.plan_interv_ehdaa,
            res_bilan.mat,
            dim.des_matiere,
            res_bilan.res_num_som,
            res_bilan.ind_reussite
        from {{ ref("fact_res_bilan_mat") }} as res_bilan
        left join
            {{ ref("fact_yearly_student") }} as y_stud
            on res_bilan.fiche = y_stud.fiche
            and res_bilan.id_eco = y_stud.id_eco
        inner join
            {{ ref("resco_dim_matiere") }} as dim on dim.cod_matiere = res_bilan.mat  -- Only keep the tracked courses
        where
            res_bilan.annee
            between {{ get_current_year() }} - 4 and {{ get_current_year() }}
            and res_bilan.res_num_som is not null
            and y_stud.genre != 'X'  -- Non binaire
            and res_bilan.ind_reprise = 0
    ),

    cal as (
        select
            *,
            case when ind_reussite = 'E' then 1 end as tx_echec,
            case when ind_reussite = 'R' then 1 end as tx_reussite,
            case
                when
                    res_num_som > 59
                    and res_num_som
                    < {{ var("res_scolaires", {"threshold": 70})["threshold"] }}
                then 1
                else 0
            end as tx_risque,
            case
                when
                    res_num_som
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
            mat,
            genre,
            des_matiere,
            plan_interv_ehdaa,
            count(res_num_som) as n_obs,
            sum(try_cast(tx_reussite as float)) as n_reussite,
            sum(try_cast(tx_risque as float)) as n_risque,
            sum(try_cast(tx_echec as float)) as n_echec,
            sum(try_cast(tx_maitrise as float)) as n_maitrise,
            avg(try_cast(res_num_som as decimal(5, 2))) as resultat_avg
        from cal
        group by annee, mat, des_matiere, cube (genre, population, plan_interv_ehdaa)
    -- Add the statistis
    ),

    totaux as (
        select
            case when population is null then 'Tout' else population end as population,
            annee,
            mat,
            des_matiere,
            case when genre is null then 'Tout' else genre end as genre,
            case
                when plan_interv_ehdaa is null then 'Tout' else plan_interv_ehdaa
            end as plan_interv_ehdaa,
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
                        "mat",
                        "genre",
                        "plan_interv_ehdaa",
                        "des_matiere",
                    ]
                )
            }} as id_mat_year,
            population,
            annee,
            mat,
            des_matiere,
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
    )
select
    -- Dimensions
    id_mat_year,
    population,
    annee,
    mat,
    genre,
    plan_interv_ehdaa,
    des_matiere,
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
