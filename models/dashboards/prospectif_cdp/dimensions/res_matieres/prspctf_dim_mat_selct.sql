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
{{ config(alias="dim_mat_selct") }}

{%- set source_relation = adapter.get_relation(
    database=target.database,
    schema=target.schema + "_prospectif_cdp_seeds",
    identifier="custom_code_matiere",
) -%}
{% set table_exists = source_relation is not none %}

{% if table_exists %}
    {% if execute %}
        {{
            log(
                "The seed '*_res_prospectif_cdp.custom_code_matiere' DOES EXIST and will be added to the 'default_code_matiere'",
                true,
            )
        }}
    {% endif %}

    select code_matiere, friendly_name, niveau_scolaire
    from {{ ref("default_code_matiere") }}
    union all
    select code_matiere, friendly_name, niveau_scolaire
    from {{ source_relation }}

{% else %}
    {% if execute %}
        {{
            log(
                "The seed '_res_prospectif_cdp.custom_code_matiere' DOES NOT exists. The 'prspctf_dim_mat_selct' table will be defaulted to 'default_code_matiere'.",
                true,
            )
        }}
    {% endif %}

    select code_matiere, friendly_name, niveau_scolaire
    from {{ ref("default_code_matiere") }}
{% endif %}
