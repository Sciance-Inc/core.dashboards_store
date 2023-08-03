
{# Macros declarations#}
{% macro init_metadata_table() %} 
    {{ return(adapter.dispatch('init_metadata_table', 'store')()) }}
{% endmacro %}


{% macro purge_metadata_table() %}
    {{ return(adapter.dispatch('purge_metadata_table', 'store')()) }}
{% endmacro %}

{% macro stamp_model(dashboard_name) %}
    {{ return(adapter.dispatch('stamp_model', 'store')(dashboard_name)) }}
{% endmacro %}


{# SQL Server dispatch #}

{% macro sqlserver__init_metadata_table() %}

    {% if execute %}

    {% set schema_name = target.schema + '_metadata'%}
    {% set table_name = target.schema + '_metadata.stamper'%}
    
        {% set query %}
-- Maybe create the schema
IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '{{ schema_name }}' )) 
BEGIN
    EXEC ('CREATE SCHEMA {{ schema_name }}' )
END

-- Maybe create the table
IF NOT EXISTS (SELECT * FROM sys.tables t JOIN sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name = '{{ schema_name }}' AND t.name = 'stamper')
CREATE TABLE {{ table_name }} (
	dashboard_name NVARCHAR(128),
	table_name NVARCHAR(128),
	run_ended_at DATETIME,
    idx NVARCHAR(256) DEFAULT (CONVERT(NVARCHAR(256), NEWID()))
	);
        {% endset %}

    {% do run_query(query) %}

    {% endif %}
{% endmacro %}

{% macro sqlserver__purge_metadata_table() %}
        -- Delete the old stamps data
        {% set table_name = target.schema + '_metadata.stamper'%}
        
        {% set query %}
        DELETE FROM {{ table_name }}
        WHERE idx=ANY(
        SELECT src.idx
        FROM 
        (
            SELECT 
                idx
                , ROW_NUMBER() OVER (PARTITION BY dashboard_name, table_name ORDER BY run_ended_at DESC) AS seqID 
            FROM {{ table_name }}
        ) AS src
        WHERE src.seqID > 1 -- Only keep the most recent run
        )

        {% endset %}

        {% do run_query(query) %}

{% endmacro %}

{% macro sqlserver__stamp_model(dashboard_name) %}

    {% set table_name = target.schema + '_metadata.stamper'%}
    {% set schema_name = target.schema + '_metadata'%}

    -- Check if the metadata table exists 
    {% set query %}
    SELECT * FROM sys.tables t JOIN sys.schemas s ON (t.schema_id = s.schema_id) WHERE s.name = '{{ schema_name }}' AND t.name = 'stamper'
    {% endset%}
    {% set result = run_query(query) %}
    {% do run_query(query) %}
    
    {% if result %}

        {% do run_query(query) %}

        -- Finish stamping the run in the metadata table
        {% set query %}
        INSERT INTO {{ table_name }} (dashboard_name, table_name, run_ended_at)
        VALUES ('{{ dashboard_name }}', '{{ this.name }}', {{ dbt.current_timestamp() }});
        {% endset %}

        {% do run_query(query) %}

    {% endif %}

{% endmacro %}