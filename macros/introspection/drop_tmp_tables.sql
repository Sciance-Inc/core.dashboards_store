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
-- This macro drops all temporary tables and views created by dbt
{# Macros declarations #}
{% macro drop_tmp_tables() %}
    {{ return(adapter.dispatch("drop_tmp_tables", "core_dashboards_store")()) }}
{% endmacro %}

{# SQL Server dispatch #}
{% macro fabric__drop_tmp_tables() %}

    {% set sql %}
    declare @sqlstatement nvarchar(max);
    select @sqlstatement = 
        coalesce(@sqlstatement, N'') + N'drop table ' + table_schema + '.' + quotename(table_name) + N';' + char(13)
    from information_schema.tables
    where 
        table_name like '%__dbt_tmp'
        and table_schema like '%{{ target.schema }}%'
    exec (@sqlstatement)
    {% endset %}

    {% do run_query(sql) %}

{% endmacro %}
