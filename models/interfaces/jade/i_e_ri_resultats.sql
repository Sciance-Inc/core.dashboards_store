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
    , ResEcoBrute AS res_eco_brute
    , ResEcoMod AS res_eco_mod
    , ResOffBrute AS res_off_brute
    , ResOffConv AS res_off_conv
    , ResOffFinal AS res_off_final
    , Annee AS annee
    , typeformcharl AS type_form_charl
    , secteurEnseignFreq AS secteur_enseign_freq
FROM 
    {{ var("database_jade") }}.dbo.E_RI_Resultats


