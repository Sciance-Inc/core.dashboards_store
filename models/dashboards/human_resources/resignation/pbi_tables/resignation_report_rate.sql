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
{{ config(alias="resignation_report_rate") }}

with

    extraction as (
        select
            fact.matr,
            fact.corp_empl,
            fact.etat_empl,
            fact.lieu_trav,
            fact.ref_empl,
            fact.school_year,
            fact.stat_eng,
            fact.genre,
            fact.legal_name,
            res.etat_empl as raisondemission,
            fact.nbremploi,
            fact.nbrdemission
        from {{ ref("fact_resignation_rate") }} fact
        left join
            {{ ref("fact_resignation") }} res
            on res.matr = fact.matr
            and res.corp_empl = fact.corp_empl
            and res.lieu_trav = fact.lieu_trav
            and res.ref_empl = fact.ref_empl
            and res.school_year = fact.school_year

    ),

    ajout_job_cat as (
        select
            ext.matr,
            ext.corp_empl,
            ext.lieu_trav,
            ext.etat_empl,
            ext.school_year,
            ext.nbremploi,
            ext.nbrdemission,
            ext.stat_eng,
            ext.genre,
            ext.legal_name,
            raisondemission,
            job.job_group_description,
            job.job_group_category

        from extraction ext
        left join
            {{ ref("dim_mapper_job_group") }} as job on job.job_group = ext.corp_empl
        where ext.school_year >= ({{ core_dashboards_store.get_current_year() }} - 10)
    ),

    ajout_filter as (
        select
            matr,
            corp_empl,
            lieu_trav,
            etat_empl,
            school_year,
            nbremploi,
            nbrdemission,
            stat_eng,
            genre,
            legal_name,
            raisondemission,
            job_group_description,
            job_group_category,
            {{
                dbt_utils.generate_surrogate_key(
                    [
                        "etat_empl",
                        "corp_empl",
                        "genre",
                        "job_group_category",
                        "lieu_trav",
                        "stat_eng",
                        "school_year",
                    ]
                )
            }} as filter_key
        from ajout_job_cat
    )

select
    matr,
    corp_empl,
    lieu_trav,
    etat_empl,
    stat_eng,
    school_year,
    genre,
    legal_name,
    raisondemission,
    job_group_description,
    job_group_category,
    nbremploi,
    nbrdemission,
    nbrdemission / nbremploi as taux_demission,
    filter_key
from ajout_filter
