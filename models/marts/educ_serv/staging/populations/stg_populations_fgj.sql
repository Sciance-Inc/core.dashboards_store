{{ config(alias='stg_populations_fgj') }}

SELECT 
    code_perm
    , id_eco
    , annee
    ,'prescolaire' AS population
FROM {{ source_or_ref('populations', 'stg_ele_prescolaire') }}
UNION  
SELECT 
    code_perm
    , id_eco
    , annee
    ,'primaire_reg' AS population
FROM {{ source_or_ref('populations', 'stg_ele_primaire_reg') }}
UNION  
SELECT 
    code_perm
    , id_eco
    , annee
    ,'primaire_adapt' AS population
FROM {{ source_or_ref('populations', 'stg_ele_primaire_adapt') }}
UNION  
SELECT 
    code_perm
    , id_eco
    , annee
    ,'secondaire_reg' AS population
FROM {{ source_or_ref('populations', 'stg_ele_secondaire_reg') }}
UNION  
SELECT 
    code_perm
    , id_eco
    , annee
    ,'secondaire_adapt' AS population
FROM {{ source_or_ref('populations', 'stg_ele_secondaire_adapt') }}
UNION
SELECT 
    code_perm
    , id_eco
    , annee
    , population
FROM {{ ref('custom_fgj_populations') }}