SELECT 
    CodePerm
	, Fiche AS fiche
    , NomAriane AS nom
    , PnomLegal AS prenom
    , EcoCenOff AS ecole
    , MatCharl AS matiere 
    , AnneeSanct AS annee_resultat
    , MoisSanct AS mois_resultat
    , DateObtensionRes AS date_resultat
    , GrpCharl AS groupe
    , ResEcoBrute AS resecobrute
    , ResEcoMod AS resecomod
    , ResOffBrute AS resoffbrute
    , ResOffConv AS resoffconv
    , ResOffFinal AS resofffinal
    , Annee AS annee
    , typeformcharl  
    , secteurEnseignFreq AS secteurenseignfreq
FROM 
    {{ var("database_jade") }}.dbo.E_RI_Resultats