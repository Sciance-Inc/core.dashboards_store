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
{% macro source_or_ref(namespace, table) %}
    {#  The macro will return the source or the ref of the model, depending on the value of 'is_context_core'.
 In your inherited project, is_context_core schould be defined as false, so that the macro will return the ref of the model.
 Setting it to true, will return the source of the model, hence, allowing the core to be run as a standalone project providing the sources as been somehow populated.
 The macro is designed to be called with the following command : `{{ source_or_ref(model) }}` #}
    {%- if var("is_context_core", False) %}

        {% if execute %}
            {{
                log(
                    'WARN : "is_context_core" is set to true. "'
                    + table
                    + '" is fetch as a source, not a ref.',
                    true,
                )
            }}
        {% endif %}

        {{- source(namespace, table) -}}

    {%- else %} {{- ref(table) -}}

    {%- endif -%}

{% endmacro %}
