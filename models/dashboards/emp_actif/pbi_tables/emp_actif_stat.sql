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
with
    rankedemployees as (
        select
            *,
            row_number() over (
                partition by
                    job_department,
                    workplace_name,
                    job_class,
                    gender,
                    is_currently_active,
                    matr
                order by matr desc
            ) as row_number
        from {{ ref("fact_emp_actif") }} as act
    ),

    agg as (
        select
            gender,
            workplace_name,
            job_class,
            job_department,
            is_currently_active,
            type,
            count(*) as total_emp_by_group,
            sum(case when gender = 'homme' then 1 else 0 end) as total_men,
            sum(case when gender = 'femme' then 1 else 0 end) as total_women,
            sum(case when is_regular = 'Oui' then 1 else 0 end) as total_etp,
            sum(case when is_currently_active = 'Oui' then 1 else 0 end) as total_actif
        from rankedemployees
        where row_number = 1
        group by
            gender, workplace_name, job_class, job_department, is_currently_active, type
    ),

    total_emp as (
        select
            gender,
            workplace_name,
            job_class,
            job_department,
            type,
            is_currently_active,
            total_men,
            total_women,
            total_etp,
            total_actif,
            total_emp_by_group,
            sum(total_emp_by_group) over () as total_count_emp
        from agg
    )

select
    *,
    {{
        dbt_utils.generate_surrogate_key(
            [
                "job_department",
                "workplace_name",
                "job_class",
                "type",
                "gender",
                "is_currently_active",
            ]
        )
    }} as filter_key
from total_emp
