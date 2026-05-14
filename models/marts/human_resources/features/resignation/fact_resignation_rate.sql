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
{# 
    Extract all the resignation date for all of the employees.
#}
-- Extract all the valid resignations etat as well as the the corps_empl, lieu_trav and
--
{{
    config(
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}",
                [
                    "matr",
                    "corp_empl",
                    "lieu_trav",
                    "school_year",
                    "etat_empl",
                    "ref_empl",
                    "stat_eng",
                ],
                unique=True,
            ),
        ],
    )
}}

with

    extraction as (
        select
            act.matr,
            act.corp_empl,
            act.lieu_trav,
            act.school_year,
            act.etat_empl,
            act.ref_empl,
            act.stat_eng,
            count(distinct(act.ref_empl)) as nbremploi,
            count(distinct(res.ref_empl)) as nbrdemission
        from {{ ref("fact_activity_yearly") }} act
        left join
            {{ ref("fact_resignation") }} res  -- left join pour aller chercher tous les employés, et non seulement ceux qui ont démissionner. 
            on res.matr = act.matr
            and res.corp_empl = act.corp_empl
            and res.lieu_trav = act.lieu_trav
            and res.ref_empl = act.ref_empl
            and res.school_year = act.school_year
            and res.stat_eng = act.stat_eng
        -- and res.etat_empl = act.etat_empl
        group by
            act.matr,
            act.corp_empl,
            act.lieu_trav,
            act.etat_empl,
            act.school_year,
            act.ref_empl,
            act.stat_eng
    )

select
    ext.matr,
    corp_empl,
    lieu_trav,
    school_year,
    etat_empl,
    ref_empl,
    nbremploi,
    nbrdemission,
    stat_eng,
    genre,
    legal_name
from extraction ext
inner join {{ ref("dim_employees") }} empl on empl.matr = ext.matr
