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
        * named 'custom_cibles_indicateurs_annuelles_pevr_cdpvd'
        * located in the schema 'dashboard_pevr_seeds'
#}

{{ config(alias="pevr_dim_cibles_annuelles") }}

{%- set source_relation = adapter.get_relation(
    database=target.database,
    schema=target.schema + "_dashboard_pevr_seeds",
    identifier="custom_cibles_indicateurs_annuelles_pevr_cdpvd",
) -%}

{% set table_exists = source_relation is not none %}

{% if table_exists %}
    {% if execute %}
        {{
            log(
                "The seed '*_dashboard_pevr_seeds.custom_cibles_indicateurs_annuelles_pevr_cdpvd' DOES EXIST and will replace the default 'cibles_indicateurs_annuelles_pevr_cdpvd'",
                true,
            )
        }}
    {% endif %}

    select
        objectif,
        id_indicateur,
        annee_scolaire,
        cible
    from {{ source_relation }}

{% else %}
    {% if execute %}
        {{
            log(
                "The seed '*_dashboard_pevr_seeds.custom_cibles_indicateurs_annuelles_pevr_cdpvd' DOES NOT exists. The 'pevr_dim_cibles_annuelles' table will be defaulted to 'cibles_indicateurs_annuelles_pevr_cdpvd'.",
                true,
            )
        }}
    {% endif %}

    select
        objectif,
        id_indicateur,
        annee_scolaire,
        cible
    from {{ ref("cibles_indicateurs_annuelles_pevr_cdpvd") }}
{% endif %}
