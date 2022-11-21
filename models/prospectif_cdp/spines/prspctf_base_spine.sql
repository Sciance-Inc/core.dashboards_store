{{ config(alias='base_spine') }}

WITH src AS (
    SELECT 
        stg.fiche
        , stg.id_eco
        , stg.population
        , dan.date_deb
    FROM {{ ref('prspctf_stg_populations_fgj') }} AS stg
    LEFT JOIN {{ ref('i_gpm_e_dan') }} AS dan 
        ON stg.fiche = dan.fiche AND stg.id_eco = dan.id_eco
        
)

SELECT 
    src.*
    , ROW_NUMBER() OVER (PARTITION BY fiche, population ORDER BY date_deb DESC) AS seqid
FROM src