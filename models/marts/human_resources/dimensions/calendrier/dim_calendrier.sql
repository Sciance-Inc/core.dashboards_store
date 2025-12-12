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
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["annee", "gr_paie"]
            )
        ],
    )
}}


with
    denombrement as (
        select
            an_budg as annee,  -- Année budgétaire
            gr_paie,  -- Groupe de paie | Pour sélectionner les employés selon leur type d'emploi 
            count(distinct date_jour) as nbjour
        from {{ ref("i_pai_tab_cal_jour") }}
        where
            type_jour not in ('C', 'E')
            and jour_sem not in (0, 6)
            and an_budg >= {{ core_dashboards_store.get_current_year() - 2 }}
            {{ (core_dashboards_store.get_current_year() - 1) }}

        group by an_budg, gr_paie
    ),

    liendate as (
        select
            an_budg as annee,
            gr_paie,
            date_jour,
            row_number() over (
                partition by an_budg, gr_paie order by date_jour
            ) as dernieredate
        from {{ ref("i_pai_tab_cal_jour") }}
        where
            type_jour not in ('C', 'E')
            and jour_sem not in (0, 6)
            and an_budg >= {{ core_dashboards_store.get_current_year() - 2 }}
            {{ (core_dashboards_store.get_current_year() - 1) }}
    )

select
    den.annee,
    den.gr_paie,
    liendate.date_jour,
    (den.nbjour - liendate.dernieredate) as bal_jour_ouv,
    {{ dbt_utils.generate_surrogate_key(["den.gr_paie", "date_jour"]) }} as filter_key
from denombrement as den
join liendate on den.annee = liendate.annee and den.gr_paie = liendate.gr_paie
;
