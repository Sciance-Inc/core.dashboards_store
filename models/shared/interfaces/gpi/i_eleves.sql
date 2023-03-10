SELECT 
    fiche
    , nom
    , prenom
    , rId
FROM {{ var("database_gpi") }}.edo.eleves