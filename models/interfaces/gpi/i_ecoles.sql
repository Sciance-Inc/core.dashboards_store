SELECT 
    annee,
    ecole,
    nomEcole AS nom_ecole,
    rId
FROM {{ var("database_gpi") }}.edo.ecoles