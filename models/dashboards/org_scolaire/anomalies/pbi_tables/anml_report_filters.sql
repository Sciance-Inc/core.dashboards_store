{#
    La table de filters pour le tableau de bord eleves doublons
#}
{{ config(alias="report_filters") }}

-- Prendre des écoles normales avec l'année scolaire pour la filtration
select
    annee,
    school_friendly_name,
    {{ dbt_utils.generate_surrogate_key(["annee", "school_friendly_name"]) }}
    as filter_key
from {{ ref("dim_mapper_schools") }}
where annee > 2009 and eco < '099'
