select annee, ecole, nomecole as nom_ecole from {{ var("database_gpi") }}.edo.ecoles
