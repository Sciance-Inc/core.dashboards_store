SELECT
	fiche
	, annee
	, dateDeb AS date_deb
	, dateFin AS date_fin
	, statut
	, org
	, ecoCen AS eco_cen
	, bat
	, client
	, freq
	, prog
	, serviceEnseign AS service_enseign
FROM
    {{ var("database_jade") }}.dbo.e_freq