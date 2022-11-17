SELECT
    fiche,
    annee,
    sk_eleve
FROM {{ ref("i_dim_eleve") }}
WHERE
    annee IS NOT NULL AND 
    fiche IS NOT NULL
GROUP BY 
    fiche,
    annee,
    sk_eleve