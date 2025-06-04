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
-- Remove temporary tables and views from the active schema for the currently modeled
-- table
-- Only the temporary schemas of the ACTIVE table are removed to avoid a race
-- condition when
-- models are run concurrently.
-- This macro is used to drop temporary tables created during the execution of dbt
-- models.
{# Macros declarations#}
{% macro drop_tmp_table_for_current_model(model_name) %}
    {{
        return(
            adapter.dispatch(
                "drop_tmp_table_for_current_model", "core_dashboards_store"
            )(model_name)
        )
    }}
{% endmacro %}

{# Fabric dispatch #}
{% macro fabric__drop_tmp_table_for_current_model(model_name) %}
    {% set tmp_table = model_name ~ "__dbt_tmp" %}
    {% set full_table_name = target.schema ~ "." ~ tmp_table %}

    {% set sql %}
        if object_id('{{ full_table_name }}', 'U') is not null
        drop table {{ full_table_name }};
    {% endset %}

    {% do run_query(sql) %}
{% endmacro %}
