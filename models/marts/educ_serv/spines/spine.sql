

WITH dan AS (
    SELECT 
        dan.fiche
        , eco.annee
        , eco.eco
        , dan.date_deb
    FROM {{ ref('i_gpm_e_dan') }} AS dan
    LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco 
        ON dan.id_eco = eco.id_eco
    WHERE dan.statut_don_an = 'A'
),

fiche AS (
    SELECT 
        stg.code_perm
        , stg.annee
        , ele.fiche
        , stg.population
    FROM {{ ref('stg_populations_fgj') }} AS stg
    LEFT JOIN {{ ref('i_gpm_e_ele') }} AS ele
        ON stg.code_perm = ele.code_perm
)

SELECT 
    fiche.*
    , dan.eco
    , ROW_NUMBER() OVER (PARTITION BY code_perm, fiche.annee, population ORDER BY date_deb DESC) AS seqid
FROM fiche
LEFT JOIN dan ON dan.fiche = fiche.fiche AND dan.annee = fiche.annee