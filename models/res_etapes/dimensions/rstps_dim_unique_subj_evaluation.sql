


select distinct 
    {{ dbt_utils.generate_surrogate_key(['annee', 'friendly_name']) }} as id_friendly_name
    ,annee
    ,friendly_name
FROM {{ ref('rstps_fact_evaluations_grades_from_dim') }}
