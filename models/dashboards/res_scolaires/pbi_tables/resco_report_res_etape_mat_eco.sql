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
        alias="report_res_etape_mat_eco",
    )
}}

with
    data as (
        select
            y_stud.population,
            eta_mat.annee,
            y_stud.nom_ecole,
            y_stud.eco,
            y_stud.genre,
            y_stud.plan_interv_ehdaa,
            eta_mat.mat,
            eta_mat.etape,
            dim.des_matiere,
            res_etape_num,
            eta_mat.ind_reussite
        from {{ ref("fact_res_etape_mat") }} as eta_mat
        left join
            {{ ref("fact_yearly_student") }} as y_stud
            on eta_mat.fiche = y_stud.fiche
            and eta_mat.id_eco = y_stud.id_eco
        inner join
            {{ ref("resco_dim_matiere") }} as dim on dim.cod_matiere = eta_mat.mat  -- Only keep the tracked courses
        where
            y_stud.annee
            between {{ get_current_year() }} - 4 and {{ get_current_year() }}
            and eta_mat.res_etape_num is not null
            and eta_mat.etape != 'EX'
            and y_stud.genre != 'X'  -- Non binaire
            and eta_mat.ind_reprise = 0
    ),

    cal as (
        select
            *,
            case when ind_reussite = 'E' then 1 end as tx_echec,
            case when ind_reussite = 'R' then 1 end as tx_reussite,
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
            nom_ecole,
            eco,
            genre,
            plan_interv_ehdaa,
            mat,
            etape,
            des_matiere,
            count(res_etape_num) as n_obs,
            sum(try_cast(tx_reussite as float)) as n_reussite,
            sum(try_cast(tx_risque as float)) as n_risque,
            sum(try_cast(tx_echec as float)) as n_echec,
            sum(try_cast(tx_maitrise as float)) as n_maitrise,
            avg(try_cast(res_etape_num as decimal(5, 2))) as resultat_avg
        from cal
        group by
            annee,
            mat,
            des_matiere,
            nom_ecole,
            etape,
            eco, cube (genre, population, plan_interv_ehdaa)

    -- Add the statistis
    ),

    totaux as (
        select
            case when population is null then 'Tout' else population end as population,
            annee,
            nom_ecole,
            eco,
            case when genre is null then 'Tout' else genre end as genre,
            case
                when plan_interv_ehdaa is null then 'Tout' else plan_interv_ehdaa
            end as plan_interv_ehdaa,
            mat,
            etape,
            des_matiere,
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
                        "etape",
                        "genre",
                        "plan_interv_ehdaa",
                    ]
                )
            }} as id_mat_year,
            population,
            annee,
            nom_ecole,
            eco,
            genre,
            plan_interv_ehdaa,
            mat,
            etape,
            des_matiere,
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
    ),
    ecart as (
        select
            stats.*,
            (stats.percent_of_success)
            - (stcss.percent_of_success) as ecart_percent_of_success,
            (stats.percent_of_risque)
            - (stcss.percent_of_risque) as ecart_percent_of_risque,
            (stats.percent_of_echec)
            - (stcss.percent_of_echec) as ecart_percent_of_echec,
            (stats.percent_of_maitrise)
            - (stcss.percent_of_maitrise) as ecart_percent_of_maitrise,
            (stats.resultat_avg) - (stcss.resultat_avg) as ecart_resultat_avg
        from stats
        left join
            {{ ref("resco_report_res_etape_mat_css") }} as stcss
            on stats.id_mat_year = stcss.id_mat_year
    )
select
    -- Dimensions
    id_mat_year,
    population,
    annee,
    nom_ecole,
    eco,
    genre,
    plan_interv_ehdaa,
    mat,
    etape,
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
    percent_of_maitrise,
    ecart_percent_of_success,
    ecart_percent_of_risque,
    ecart_percent_of_echec,
    ecart_percent_of_maitrise,
    ecart_resultat_avg
from ecart
