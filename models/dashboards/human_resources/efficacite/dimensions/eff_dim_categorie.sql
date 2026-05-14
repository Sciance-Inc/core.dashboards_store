-- Dit a dbt quelles modèles sont des références possibles.
-- depends_on: {{ ref('eff_categories_emploi_personnalises') }}
-- depends_on: {{ ref('eff_categories_emploi') }}
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
{# 

    The default table is defined in the core repo while the custom table, as all the CSSs specifics table is created in the repo css.

    The code check for the custom table existence and replace it to the default table
    For the CUSTOM table to be detected, the table must be :
        * named 'eff_categories_emploi_personnalises'
        * located in the schema '_dashboard_efficacite_seeds'
#}
{%- set source_relation = adapter.get_relation(
    database=target.database,
    schema=target.schema + "_dashboard_efficacite_seeds",
    identifier="eff_categories_emploi_personnalises",
) -%}
{% set table_exists = source_relation is not none %}

{% if table_exists %}
    {% if execute %}
        {{
            log(
                "The seed 'eff_categories_emploi_personnalises' DOES EXIST in schema '"
                ~ target.schema
                ~ "_dashboard_efficacite_seeds' and will replace the 'categories_emploi'",
                true,
            )
        }}
    {% endif %}

    select corp_empl, description_corps_empl, categorie
    from {{ ref("eff_categories_emploi_personnalises") }}

{% else %}
    {% if execute %}
        {{
            log(
                "The seed '_efficacite_seeds.eff_categories_emploi_personnalises' DOES NOT exist in schema '"
                ~ target.schema
                ~ "_dashboard_efficacite_seeds'. The 'eff_dim_categorie' table will default to 'categories_emploi'.",
                true,
            )
        }}
    {% endif %}

    select corp_empl, description_corps_empl, categorie
    from {{ ref("eff_categories_emploi") }}
{% endif %}
