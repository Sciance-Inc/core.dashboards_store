SELECT 
    annee,
    fiche,
    statut,
    niveauScolaire AS niveau_scolaire,
    ecole,
    GroupeRepere As groupe_repere,
    Age30Sept AS age_30_septembre,
    classification,
    rid
FROM {{ var("database_gpi") }}.edo.dossiers