{{ config(alias='stg_populations_fgj') }}

SELECT 
    fiche
    , id_eco
    ,'prescolaire' AS population
FROM {{ adapt('populations', 'prspctf_stg_el_prescolaire') }}
UNION  
SELECT 
    fiche
    , id_eco
    ,'primaire_reg' AS population
FROM {{ adapt('populations', 'prspctf_stg_el_primaire_reg') }}
UNION  
SELECT 
    fiche
    , id_eco
    ,'primaire_adapt' AS population
FROM {{ adapt('populations', 'prspctf_stg_el_primaire_adapt') }}
UNION  
SELECT 
    fiche
    , id_eco
    ,'secondaire_reg' AS population
FROM {{ adapt('populations', 'prspctf_stg_el_sec_reg') }}
UNION  
SELECT 
    fiche
    , id_eco
    ,'secondaire_adapt' AS population
FROM {{ adapt('populations', 'prspctf_stg_el_sec_adapt') }}