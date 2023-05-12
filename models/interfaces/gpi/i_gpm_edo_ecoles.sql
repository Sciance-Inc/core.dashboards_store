SELECT 
      annee,
      ecole,
      nomEcole AS nom_ecole
FROM {{ var("database_gpi") }}.edo.Ecoles