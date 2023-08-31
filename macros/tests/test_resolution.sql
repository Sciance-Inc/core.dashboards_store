{# make sure the resolution unique per cols_list #}
{% test resolution(model, combination_of_columns) %}

    select val.*
    from
        (
            select
                {% for col in combination_of_columns -%} {{- col -}}, {% endfor -%}
                count(*) as obs
            from {{ model }}
            group by
                {% for col in combination_of_columns -%}
                    {% if not loop.last %} {{- col -}},
                    {% else %} {{- col }}
                    {%- endif -%}
                {% endfor %}
        ) as val
    where val.obs > 1

{% endtest %}
