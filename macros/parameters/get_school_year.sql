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
{% macro get_school_year(date_expression) %}
    {% set start_month = var("school_year_start_month", 9) %}

    {% if start_month is not integer or start_month < 1 or start_month > 12 %}
        {{
            exceptions.raise_compiler_error(
                "'school_year_start_month' must be an integer between 1 and 12."
            )
        }}
    {% endif %}

    {{
        return(
            adapter.dispatch("get_school_year", "core_dashboards_store")(
                date_expression, start_month
            )
        )
    }}
{% endmacro %}

{% macro fabric__get_school_year(date_expression, start_month) %}
    case
        when month({{ date_expression }}) >= {{ start_month }}
        then year({{ date_expression }})
        else year({{ date_expression }}) - 1
    end
{% endmacro %}
