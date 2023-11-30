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
    Compute a yearly version of the employment history restricted to only active status
#}
with
    currentactive as (
        select matr, corp_empl, etat_empl, stat_eng, 1 as 'currently_active'
        from {{ ref("fact_activity_current") }}
    )

select
    util.matr,
    util.first_name + ' ' + util.last_name as full_name,
    util.email_address,
    emp.etat as state,
    emp.lieu_trav as workplace,
    util.sex,
    emp.corp_empl,
    emp.mode_cour,
    emp.type,
    emp.stat_eng,
    emp.etat,
    ca.currently_active
from {{ ref("dim_employees") }} as util
left join {{ ref("i_pai_dos_empl") }} emp on util.matr = emp.matr
left join currentactive ca on util.matr = ca.matr
where emp.etat like 'a%' and emp.ind_empl_princ = 1
