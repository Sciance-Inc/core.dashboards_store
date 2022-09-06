SELECT 
    CodePerm
    , Annee
    , Freq
    , DateDeb
    , DateFin
    , 'FGA' AS population
FROM {{ adapt('features', 'fact_freq_fga') }}
UNION  
SELECT 
    CodePerm
    , Annee
    , Freq
    , DateDeb
    , DateFin
    , 'FP' AS population
FROM {{ adapt('features', 'fact_freq_fp') }}
