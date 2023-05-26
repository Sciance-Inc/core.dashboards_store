{{ config(alias='stg_populations_fgj') }}

SELECT 
    code_perm
    , annee
    ,'prescolaire' AS population
FROM {{ adapt('populations', 'stg_ele_prescolaire') }}
UNION  
SELECT 
    code_perm
    , annee
    ,'primaire_reg' AS population
FROM {{ adapt('populations', 'stg_ele_primaire_reg') }}
UNION  
SELECT 
    code_perm
    , annee
    ,'primaire_adapt' AS population
FROM {{ adapt('populations', 'stg_ele_primaire_adapt') }}
UNION  
SELECT 
    code_perm
    , annee
    ,'secondaire_reg' AS population
FROM {{ adapt('populations', 'stg_ele_secondaire_reg') }}
UNION  
SELECT 
    code_perm
    , annee
    ,'secondaire_adapt' AS population
FROM {{ adapt('populations', 'stg_ele_secondaire_adapt') }}