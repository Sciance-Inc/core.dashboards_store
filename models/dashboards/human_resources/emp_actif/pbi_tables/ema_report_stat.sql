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
{{ config(alias="report_stat") }}

with

    agg as (
        select
            sex_friendly_name,
            workplace_name,
            job_class,
            job_department,
            is_current,
            type_,
            count(matr) as total_emp_by_group,
            sum(case when sex_friendly_name = 'homme' then 1 else 0 end) as total_men,
            sum(case when sex_friendly_name = 'femme' then 1 else 0 end) as total_women,
            sum(case when is_regular = 1 then 1 else 0 end) as total_etp,
            sum(case when is_current = 1 then 1 else 0 end) as emp_cur,
            count(case when is_current = 1 then 1 else 0 end) as total_emp_by_group_act,
            sum(
                case
                    when sex_friendly_name = 'homme' and is_current = 1 then 1 else 0
                end
            ) as total_men_act,
            sum(
                case
                    when sex_friendly_name = 'femme' and is_current = 1 then 1 else 0
                end
            ) as total_women_act,
            sum(
                case when is_regular = 1 and is_current = 1 then 1 else 0 end
            ) as total_etp_act,
            count(matr) as total_actif
        from {{ ref("emp_actif_fact_base") }}
        group by
            sex_friendly_name,
            workplace_name,
            job_class,
            job_department,
            type_,
            is_current
    ),

    total_emp as (
        select
            sex_friendly_name,
            workplace_name,
            job_class,
            job_department,
            type_,
            is_current,
            total_men,
            total_women,
            total_etp,
            total_men_act,
            total_women_act,
            total_etp_act,
            total_emp_by_group,
            total_emp_by_group_act,
            total_actif,
            emp_cur,
            sum(emp_cur) over () as total_count_emp_act,
            sum(total_emp_by_group) over () as total_count_emp
        from agg
    )

select
    total_men,
    total_women,
    total_etp,
    total_men_act,
    total_women_act,
    total_etp_act,
    total_emp_by_group,
    total_emp_by_group_act,
    total_actif,
    emp_cur,
    total_count_emp_act,
    total_count_emp,
    job_department,
    {{
        dbt_utils.generate_surrogate_key(
            [
                "job_department",
                "workplace_name",
                "job_class",
                "type_",
                "sex_friendly_name",
                "is_current",
            ]
        )
    }} as filter_key
from total_emp
