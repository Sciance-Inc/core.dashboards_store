{% macro adapt(namespace, table) %}

{%- if var("is_context_core", False) %}
    {{- source(namespace, table) -}}

{%- else %}
    {% set table_exists=source(namespace, table) is not none %}
    
    {{ log(namespace, info=True) }}
    {{ log(table, info=True) }}
    {{ log(source(namespace, table), info=True) }}
    {{ log(table_exists, info=True) }}

    {%- if table_exists %}
        {{ log("Table exist", info=True) }}
        {{- ref(table) -}}

    {%- else %}
        {{- log("Table doesn't exist", info=True) }}
    {%- endif %}

{%- endif -%}

{% endmacro %}