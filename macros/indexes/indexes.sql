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
-- Thoose macro schould be defined at the adatper level.
-- Since it's unclear if we are gonna switch to Snowflake, and still support SQL
-- server, we are gonna define them here.
-- Regular, garden variety indexes.
{% macro create_clustered_index(table_name, columns, unique=False) %}
    {{
        return(
            adapter.dispatch("create_clustered_index", "core_dashboards_store")(
                table_name, columns, unique
            )
        )
    }}
{% endmacro %}

{% macro create_nonclustered_index(table_name, columns, unique=False) %}
    {{
        return(
            adapter.dispatch("create_nonclustered_index", "core_dashboards_store")(
                table_name, columns, unique
            )
        )
    }}
{% endmacro %}

-- The Big deal, the Columnstore indexes.
{% macro create_clustered_columnstore_index(table_name, columns) %}
    {{
        return(
            adapter.dispatch(
                "create_clustered_columnstore_index", "core_dashboards_store"
            )(table_name, columns)
        )
    }}
{% endmacro %}

{% macro create_nonclustered_columnstore_index(table_name, columns) %}
    {{
        return(
            adapter.dispatch(
                "create_nonclustered_columnstore_index", "core_dashboards_store"
            )(table_name, columns)
        )
    }}
{% endmacro %}


-- Vanilla indexes
{% macro fabric__create_clustered_index(table_name, columns, unique) %}

    {% set index_name = "idx_" + columns | join("_") %}
    {% if unique %}

        {% set query %}
CREATE UNIQUE CLUSTERED INDEX {{ index_name }} ON {{ table_name }} ({{ columns | join(", ") }});
        {% endset %}

    {% else %}

        {% set query %}
CREATE CLUSTERED INDEX {{ index_name }} ON {{ table_name }} ({{ columns | join(", ") }});
        {% endset %}
    {% endif %}

    {{ return(query) }}

{% endmacro %}


{% macro fabric__create_nonclustered_index(table_name, columns, unique) %}

    {% set index_name = "idx_" + columns | join("_") %}

    {% if unique %}

        {% set query %}
CREATE UNIQUE INDEX {{ index_name }} ON {{ table_name }} ({{ columns | join(", ") }});
        {% endset %}

    {% else %}

        {% set query %}
CREATE INDEX {{ index_name }} ON {{ table_name }} ({{ columns | join(", ") }});
        {% endset %}

    {% endif %}

    {{ return(query) }}

{% endmacro %}


-- Columnstore
{% macro fabric__create_clustered_columnstore_index(table_name, columns) %}

    {% set index_name = "idx_" + columns | join("_") %}

    {% if columns | length == 0 %}
        {% set query %}
CREATE CLUSTERED COLUMNSTORE INDEX {{ index_name }} ON {{ table_name }};
        {% endset %}

    {% else %}
        {% set query %}
CREATE CLUSTERED COLUMNSTORE  INDEX {{ index_name }} ON {{ table_name }} ({{ columns | join(", ") }});
        {% endset %}
    {% endif %}

    {{ return(query) }}

{% endmacro %}

{% macro fabric__create_nonclustered_columnstore_index(table_name, columns) %}

    {% set index_name = "idx_" + columns | join("_") %}

    {% if columns | length == 0 %}
        {% set query %}
CREATE NONCLUSTERED COLUMNSTORE INDEX {{ index_name }} ON {{ table_name }};
        {% endset %}

    {% else %}
        {% set query %}
CREATE NONCLUSTERED COLUMNSTORE INDEX {{ index_name }} ON {{ table_name }} ({{ columns | join(", ") }});
        {% endset %}
    {% endif %}

    {{ return(query) }}

{% endmacro %}
