

SELECT 
     annee
    , ecole
    , fiche
    , etat
    , CodeMatiere AS code_matiere
    , MatiereGroupe AS groupe_matiere
    , resultat
    , ResultatNumerique AS resultat_numerique 
    , CodeReussite AS code_reussite  
    , rid
FROM {{ var("database_gpi") }}.edo.MatieresEleve