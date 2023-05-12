SELECT 
    fiche,
    ecole,
    annee,
    codeMatiere AS code_matiere,
    etape,
    noCompetence AS no_competence,
    resultat,
    resultatNumerique AS resultat_numerique,
    codeReussite AS code_reussite
FROM {{ var("database_gpi") }}.edo.ResultatsCompetenceEtape
