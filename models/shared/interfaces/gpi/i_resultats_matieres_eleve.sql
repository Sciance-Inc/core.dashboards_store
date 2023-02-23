

SELECT 
     annee
    , ecole
    , fiche
    , CodeMatiere AS code_matiere
    , MatiereGroupe AS groupe_matiere
    ,ResultatNumerique AS resultat_numerique 
    ,CodeReussite AS code_reussite  
FROM {{ var("database_gpi") }}.edo.MatieresEleve