{#
  Map each school to it's friendly name.

  Feel free to override me to get your own custom litle mapping.
#}

SELECT 
    id_eco
    , annee
    , eco
    , CONCAT('(', eco, ') - ', nom_eco) AS school_friendly_name
FROM {{ ref('i_gpm_t_eco') }}
