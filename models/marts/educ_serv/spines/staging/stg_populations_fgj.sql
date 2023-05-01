{{ config(alias='stg_populations_fgj') }}

SELECT 
    fiche
    , annee
    , id_eco
    ,'prescolaire' AS population
FROM {{ adapt('populations', 'stg_ele_prescolaire') }}
UNION  
SELECT 
    fiche
    , annee
    , id_eco
    ,'primaire_reg' AS population
FROM {{ adapt('populations', 'stg_ele_primaire_reg') }}
UNION  
SELECT 
    fiche
    , annee
    , id_eco
    ,'primaire_adapt' AS population
FROM {{ adapt('populations', 'stg_ele_primaire_adapt') }}
UNION  
SELECT 
    fiche
    , annee
    , id_eco
    ,'secondaire_reg' AS population
FROM {{ adapt('populations', 'stg_ele_secondaire_reg') }}
UNION  
SELECT 
    fiche
    , annee
    , id_eco
    ,'secondaire_adapt' AS population
FROM {{ adapt('populations', 'stg_ele_secondaire_adapt') }}