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
    This table unionize the always-present DEFAULT table and maybe-present CUSTOM table.
    The default table is defined in the core repo while the custom table, as all the CSS''s specifics table is created in the repo css.

    The code check for the custom table existence and adds it to the default table
    For the CUSTOM table to be detected, the table must be :
        * named 'custom_indicateurs_pevr_charl'
        * located in the schema 'dashboard_pevr_seeds'
#}

{{ config(alias="dim_indicateur_charl") }}

{%- set source_relation = adapter.get_relation(
    database=target.database,
    schema=target.schema + "_dashboard_pevr_seeds",
    identifier="custom_indicateurs_pevr_charl",
) -%}

{% set table_exists = source_relation is not none %}

{% if table_exists %}
    {% if execute %}
        {{
            log(
                "The seed '*_dashboard_pevr_seeds.custom_indicateurs_pevr_charl' DOES EXIST and will replace the default 'commun_indicateurs_pevr_charl'",
                true,
            )
        }}
    {% endif %}

    select
		id_indicateur_meq,
        id_indicateur_css,
        annee_scolaire,
        taux,
        cible
    from {{ source_relation }}

{% else %}
    {% if execute %}
        {{
            log(
                "The seed '*_dashboard_pevr_seeds.custom_indicateurs_pevr_charl' DOES NOT exists. The 'pevr_dim_indicateur_charl' table will be defaulted to 'commun_indicateurs_pevr_charl'.",
                true,
            )
        }}
    {% endif %}

    select
		id_indicateur_meq,
        id_indicateur_css,
        annee_scolaire,
        taux,
        cible
    from {{ ref("commun_indicateurs_pevr_charl") }}
{% endif %}
