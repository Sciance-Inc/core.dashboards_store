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
{{ config(alias="fact_masse_sal_corp_emp") }}

with
    src as (
        select
            pcb.annee_budgetaire,
            sum(pcb.cumulatif) as cumulatif,
            pcb.corp_empl as corp_empl
        from {{ ref("i_pai_cum_budg") }} as pcb
        where (code_pmnt_ded like '1%' or code_pmnt_ded like '2%')  -- salaire brute (1% et 2%)
        group by pcb.annee_budgetaire, pcb.corp_empl, pcb.matricule

    ),
    mass as (

        select
            left(annee_budgetaire, 4) annee_budgetaire,
            corp_empl,
            avg(cumulatif) as sal_moy_corp_emp,
            sum(cumulatif) as masse_salariale_corp_emp
        from src
        group by annee_budgetaire, corp_empl
    )
select
    annee_budgetaire,
    corp_empl,
    sal_moy_corp_emp,
    sum(masse_salariale_corp_emp) over (
        partition by annee_budgetaire
        order by annee_budgetaire
        rows between unbounded preceding and unbounded following
    ) as masse_salariale_an
from mass
