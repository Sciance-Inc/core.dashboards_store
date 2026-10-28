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
{# Source periods have inclusive bounds; nested overlaps must also fail. #}
{% test no_overlapping_employment_periods(model) %}

    select val.*
    from
        (
            select
                matr,
                ref_empl,
                date_eff,
                date_fin,
                max(date_fin) over (
                    partition by matr, ref_empl
                    order by date_eff
                    rows between unbounded preceding and 1 preceding
                ) as previous_max_date_fin
            from {{ model }}
        ) as val
    where date_eff <= previous_max_date_fin

{% endtest %}
