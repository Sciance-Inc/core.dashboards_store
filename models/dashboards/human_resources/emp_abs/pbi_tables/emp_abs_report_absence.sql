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
        alias="report_absence",
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["annee", "matricule"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["date", "corp_empl", "lieu_trav"]
            ),
        ],
    )
}}

with
    absences_employe_final as (
        select
            concat(left(abs.annee, 4), '-', left(abs.annee, 4) + 1) as annee,
            abs.matricule,
            emp.legal_name as nom,
            emp.sex_friendly_name as genre,
            case
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    < 25
                then '24 ans et moins'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 25 and 34
                then '25 à 34 ans'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 35 and 44
                then '35 à 44 ans'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 45 and 54
                then '45 à 54 ans'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 55 and 64
                then '55 à 64 ans'
                else '65 ans et plus'
            end as tranche_age,
            datediff(
                year, emp.birth_date, cast(left(abs.annee, 4) + '-07-01' as date)
            ) as age,
            jg.job_group + ' - ' + jg.job_group_description as corp_empl,
            jg.code_job_name as code_job_name,
            wp.workplace_name as lieu_trav,
            sec.secteur_descr as secteur,
            jg.job_group_category as cat_emp,
            abs.categorie,
            jds_lundi,
            jds_mardi,
            jds_mercredi,
            jds_jeudi,
            jds_vendredi,
            duree_descr,
            date,
            jour_absence,
            hr_abs,
            etc_abs,
            abs.gr_paie
        from {{ ref("fact_absence") }} as abs

        inner join {{ ref("dim_employees") }} as emp on abs.matricule = emp.matr

        left join {{ ref("secteur") }} as sec on abs.lieu_trav = sec.lieu_trav

        inner join
            {{ ref("dim_mapper_job_group") }} as jg on abs.corp_empl = jg.job_group

        inner join
            {{ ref("dim_mapper_workplace") }} as wp on abs.lieu_trav = wp.workplace
    )

select
    *,
    {{
        dbt_utils.generate_surrogate_key(
            [
                "gr_paie",
                "date",
            ]
        )
    }} as filter_key
from absences_employe_final
