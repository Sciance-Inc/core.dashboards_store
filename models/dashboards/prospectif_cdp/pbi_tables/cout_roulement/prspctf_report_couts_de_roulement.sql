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
{{ config(alias="report_couts_de_roulement") }}

with
    src as (
        select msce.*, emoq.nb_empl_aremp
        from {{ ref("prspctf_fact_masse_sal_corp_empl") }} as msce
        left join
            {{ ref("prspctf_fact_emp_quitter") }} as emoq
            on msce.annee_budgetaire = emoq.annee_budgetaire
            and msce.corp_empl = emoq.corp_empl
    ),
    agg as (
        select
            annee_budgetaire,
            case
                when annee_budgetaire = {{ store.get_current_year() }}
                then lag(masse_salariale_an) over (order by annee_budgetaire asc)
                else masse_salariale_an
            end as masse_salariale_an,
            sum(sal_moy_corp_emp * nb_empl_aremp) as couts_de_roulement

        from src
        group by annee_budgetaire, masse_salariale_an
    )
select
    annee_budgetaire,
    cast(
        ((couts_de_roulement / masse_salariale_an)) as decimal(5, 5)
    ) as ratio_couts_roulement
from agg
