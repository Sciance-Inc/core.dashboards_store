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
{% test max_le_zero(model, columns_to_verify) %}

select *
from (
    select
        {% for col in columns_to_verify -%}
            max({{ col }}) as {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    from {{ model }}
) as val
where
{% for col in columns_to_verify %}
    {% if not loop.first %} or {% endif %}
    {{ col }} > 0
{% endfor %}

{% endtest %}
