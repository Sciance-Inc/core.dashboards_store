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
        alias="report_emp_conge",
    )
}}

with
    agg as (
        select
            annee,
            lieu_trav,
            lieu_trav_descr,
            corps_demploi_description,
            etat_description,
            cong_lt,
            count(matricule) as n_matr
        from {{ ref("empcong_fact_emp_conge") }}
        where
            annee
            between {{ store.get_current_year() }}
            - 10 and {{ store.get_current_year() }}
        group by
            annee,
            lieu_trav,
            lieu_trav_descr,
            corps_demploi_description,
            etat_description,
            cong_lt
    )

select
    annee,
    concat(lieu_trav, ' | ', lieu_trav_descr) as lieu_trav,
    corps_demploi_description,
    etat_description,
    n_matr,
    case when cong_lt = 1 then 'Oui' else 'Non' end as cong_lt
from agg
