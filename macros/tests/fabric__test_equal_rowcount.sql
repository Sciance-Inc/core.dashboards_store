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
{% macro fabric__test_equal_rowcount(model, compare_model, group_by_columns=[]) %}
    {{ config(fail_calc="coalesce(sum(diff_count), 0)") }}

    select
        {% for column in group_by_columns %}
            a.{{ column }} as {{ column }}_a, b.{{ column }} as {{ column }}_b,
        {% endfor %}
        coalesce(a.row_count, 0) as count_a,
        coalesce(b.row_count, 0) as count_b,
        abs(coalesce(a.row_count, 0) - coalesce(b.row_count, 0)) as diff_count
    from
        (
            select
                {% for column in group_by_columns %} {{ column }}, {% endfor %}
                count_big(*) as row_count
            from {{ model }}
            {% if group_by_columns %}
                group by {{ group_by_columns | join(", ") }}
            {% endif %}
        ) as a
    full outer join
        (
            select
                {% for column in group_by_columns %} {{ column }}, {% endfor %}
                count_big(*) as row_count
            from {{ compare_model }}
            {% if group_by_columns %}
                group by {{ group_by_columns | join(", ") }}
            {% endif %}
        ) as b
        on {% if group_by_columns %}
            {% for column in group_by_columns %}
                {% if not loop.first %} and {% endif %}
                (
                    a.{{ column }} = b.{{ column }}
                    or (a.{{ column }} is null and b.{{ column }} is null)
                )
            {% endfor %}
        {% else %} 1 = 1
        {% endif %}
{% endmacro %}
