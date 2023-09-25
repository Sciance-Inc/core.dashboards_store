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
-- The macro will drop the target.schema AND the schemas derived from target.schema
{% macro drop_schema() %}

    {% set sql %}
    DECLARE @SqlStatement NVARCHAR(MAX);
    SELECT @SqlStatement = 
        COALESCE(@SqlStatement, N'') + N'DROP TABLE ' + TABLE_SCHEMA + '.' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA LIKE '%{{ target.schema }}%' and TABLE_TYPE = 'BASE TABLE';
    EXEC (@SqlStatement);
    {% endset %}

    {% do run_query(sql) %}

    {% set sql %}
    DECLARE @SqlStatement NVARCHAR(MAX);
    SELECT @SqlStatement = 
        COALESCE(@SqlStatement, N'') + N'DROP VIEW ' + TABLE_SCHEMA + '.' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA LIKE '%{{ target.schema }}%' and TABLE_TYPE = 'VIEW';
    EXEC (@SqlStatement);
    {% endset %}

    {% do run_query(sql) %}

    {% set sql %}
    DECLARE @SqlStatement NVARCHAR(MAX);
    SELECT @SqlStatement = 
        COALESCE(@SqlStatement, N'') + N'DROP SCHEMA ' + QUOTENAME(name) + N';' + CHAR(13)
    FROM sys.schemas 
    WHERE name LIKE '%{{ target.schema }}%' AND name != 'dbo';
    EXEC (@SqlStatement);
    {% endset %}

    {% do run_query(sql) %}

{% endmacro %}
