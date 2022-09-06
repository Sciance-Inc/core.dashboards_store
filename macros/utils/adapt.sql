{% macro adapt(namespace, table) %}
{%- if var("is_context_core", False) %}
{{- source(namespace, table) -}}
{% else %}
{{- ref(table) -}}
{%- endif -%}
{% endmacro %}