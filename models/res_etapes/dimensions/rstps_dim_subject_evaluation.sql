{# 
    
    This table unionize the always-present DEFAULT table and maybe-present CUSTOM table.
    The default table is defined in the core repo while the custom table, as all the CSS's specifics table is created in the repo css.

    The code check for the custom table existence and adds it to the default table
    For the CUSTOM table to be detected, the table must be :
        * named 'custom_subject_evaluation'
        * located in the schema 'res_etapes_seeds'
#}
{{ config(alias='dim_subject_evaluation') }}

{%- set source_relation = adapter.get_relation(
      database=target.database,
      schema=target.schema +'_res_etapes_seeds',
      identifier='custom_subject_evaluation') -%}
{% set table_exists=source_relation is not none %}

{% if table_exists %}
    {% if execute %}
    {{ log("The seed '*_res_etapes_seeds.custom_subject_evaluation' DOES EXIST and will be added to the 'default_subject_evaluation'", true) }}
    {% endif %}

SELECT 
    code_matiere,
    no_competence,
    'EX' AS code_etape,
    friendly_name
FROM {{ ref('default_subject_evaluation') }}
UNION ALL
select
    code_matiere,
    no_competence,
    code_etape,
    friendly_name
from {{ source_relation }} 

{% else %}
    {% if execute %}
    {{ log("The seed '*_res_etapes_seeds.custom_subject_evaluation' DOES NOT exists. The 'rstp_dim_subject_evaluation' table will be defaulted to 'default_subject_evaluation'.", true) }}
    {% endif %}

SELECT 
    code_matiere,
    no_competence,
    'EX' AS code_etape,
    friendly_name
FROM {{ ref('default_subject_evaluation') }}
{% endif %}