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
