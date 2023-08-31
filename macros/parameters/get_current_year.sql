{% macro get_current_year() %}

    {# If the current year is manually defined, then returned it #}
    {% if var("current_year", False) %}
        {% if execute %}
            {{
                log(
                    "The 'current_year' variable is defined and will override the autoguessed year. ",
                    true,
                )
            }}
        {% endif %}
        {{ return(var("current_year")) }}
    {% endif %}

    {# Extract the year we want to score the students for #}
    {%- call statement("year", fetch_result=true) -%}
        select
            case
                -- The current year is the start of the scholar year if we are before
                -- the end of the year (august) else it's the year.
                when month(getdate()) <= 6 then year(getdate()) - 1 else year(getdate())
            end as current_year
    {%- endcall -%}

    {# Extract the first entry of the payload :: about the execute statment : https://discourse.getdbt.com/t/help-with-call-statement-error-none-has-no-attribute-table/602/2 #}
    {% if execute %}
        {%- set result = (
            load_result("year").table.columns["current_year"].values()[0]
        ) -%}
        {{ return(result) }}
    {% else %} {{ return(false) }}
    {% endif %}

{% endmacro %}
