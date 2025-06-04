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
{% macro seeds_validator(seed_schema_name, seeds_pattern, expected_row_count) %}
    {% if execute %}

        -- Le schema du dashboard.
        {% set metadata_schema = target.schema + "_seeds_metadata" %}
        -- Le nom de la table qui contient seeds_validator.
        {% set metadata_table = metadata_schema + ".validator" %}

        -- Create the metadata schema and table if they dont exist
        {% set create_query %}
            IF (NOT EXISTS (SELECT * FROM sys.schemas WHERE name = '{{ metadata_schema }}'))
            BEGIN
                EXEC ('CREATE SCHEMA {{ metadata_schema }}')
            END

            IF NOT EXISTS (
                SELECT * 
                FROM sys.tables t 
                JOIN sys.schemas s ON t.schema_id = s.schema_id 
                WHERE s.name = '{{ metadata_schema }}' 
                AND t.name = 'validator'
            )
            BEGIN
                CREATE TABLE {{ metadata_table }} (
                    table_name NVARCHAR(256),  
                    result BIT,
                    run_ended_at DATETIME DEFAULT {{ dbt.current_timestamp() }},
                    CONSTRAINT PK_validator PRIMARY KEY (table_name)  
                );
            END
        {% endset %}

        -- Éxécute la query ci-dessus pour créer la table
        {% do run_query(create_query) %}

        -- Retourne le nombre de seeds selon le schema et le pattern --
        {% set query %}
            SELECT COUNT(*) AS row_count
            FROM sys.tables t
            JOIN sys.schemas s ON t.schema_id = s.schema_id
            WHERE s.name LIKE '%{{ seed_schema_name }}%'
                AND t.name LIKE '%{{ seeds_pattern }}%' 
        {% endset %}
        -- Le nombre de seed détecter seleon le schema et le pattern
        {% set result = run_query(query) %}
        -- Le résultat du count
        {% set actual_row_count = result.columns[0].values()[0] %}

        -- Vérifie si on respect le nombre de seeds requis et on met donc à jour en
        -- conséquence, si le seed_schema_name existe --
        {% if actual_row_count | int == expected_row_count | int %}
            {{
                log(
                    "✅ Le nombre attendu de seeds pour le schéma "
                    ~ seed_schema_name
                    ~ " est: "
                    ~ expected_row_count
                    ~ " ✅",
                    info=True,
                )
            }}
            {% set upsert_query %}
                MERGE INTO {{ metadata_table }} AS target
                USING (SELECT '{{ seed_schema_name }}' AS table_name, 1 AS result) AS source
                ON target.table_name = source.table_name
                WHEN MATCHED THEN
                    UPDATE SET result = 1, run_ended_at = {{ dbt.current_timestamp() }}
                WHEN NOT MATCHED THEN
                    INSERT (table_name, result, run_ended_at)
                    VALUES (source.table_name, source.result, {{ dbt.current_timestamp() }});
            {% endset %}

            {% do run_query(upsert_query) %}
        -- Si on respect, pas on change la colonne result à 0 (false)
        {% else %}
            {{
                log(
                    "❌ Le nombre attendu de seeds pour le schéma "
                    ~ seed_schema_name
                    ~ " est inférieur à "
                    ~ expected_row_count
                    ~ ". Nombre de seed trouvé: "
                    ~ actual_row_count
                    ~ " ❌",
                    info=True,
                )
            }}
            {% set upsert_query %}
                MERGE INTO {{ metadata_table }} AS target
                USING (SELECT '{{ seed_schema_name }}' AS table_name, 0 AS result) AS source
                ON target.table_name = source.table_name
                WHEN MATCHED THEN
                    UPDATE SET result = 0, run_ended_at = {{ dbt.current_timestamp() }}
                WHEN NOT MATCHED THEN
                    INSERT (table_name, result, run_ended_at)
                    VALUES (source.table_name, source.result, {{ dbt.current_timestamp() }});
            {% endset %}

            {% do run_query(upsert_query) %}
        {% endif %}

    {% endif %}
{% endmacro %}
