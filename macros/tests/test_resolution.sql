{# make sure the resolution unique per cols_list #}
{% test resolution(model, combination_of_columns) %}

SELECT
    val.*
FROM
    (
        SELECT
            {% for col in combination_of_columns -%}
            {{- col -}},
            {% endfor -%}
            COUNT(*) AS obs
        FROM
            {{ model }}
        GROUP BY 
            {% for col in combination_of_columns -%}
            {% if not loop.last %} {{- col -}},
            {% else %} {{- col }}
            {%- endif -%}
            {% endfor %}
    ) AS val
WHERE
    val.obs > 1  

{% endtest %}