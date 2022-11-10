WITH src AS (
    SELECT 
        map.fiche,
        map.annee,
        pop.sk_eleve
    FROM {{ ref('stg_pop_test') }} AS pop
    INNER JOIN {{ ref('bridge_sk_eleve_to_fiche') }} AS map
    ON pop.sk_eleve = map.sk_eleve
)

SELECT 
    src.*,
    ROW_NUMBER() OVER (PARTITION BY src.fiche, src.annee ORDER BY el.dat_debut_version DESC, el.dat_debut_frequentation DESC) AS sk_eleve_seqid
FROM src
LEFT JOIN {{ ref('i_dim_eleve') }} AS el
ON src.sk_eleve = el.sk_eleve