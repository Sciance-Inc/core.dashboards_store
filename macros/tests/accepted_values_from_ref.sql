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
{% test accepted_values_from_ref(
    model,
    target_column,
    ref_table,
    ref_column,
    target_join_fields=None,
    ref_join_fields=None
) %}
    {# 
    Check if all the value of the target column are in the ref_table.ref_columns.
    Implemented through minimally joining on the ref_column = ref_table.
    Additional join clauses can be added through the ref_join_fields and target_join_fields.
    Both of thoose fields are List field.
#}
    {% set ref_col = [ref_column] + ref_join_fields %}
    {% set target_col = [target_column] + target_join_fields %}

    select ref.{{ ref_column }}
    from {{ model }} as ref
    left join
        {{ ref_table }} as trg
        on {% for l, r in zip(ref_col, target_col) | list -%}
            ref.{{ l }} = trg.{{ r }} {% if not loop.last -%} and {% endif %}

        {% endfor %}
    where trg.{{ target_column }} is null

{% endtest %}
