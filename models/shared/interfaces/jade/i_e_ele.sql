SELECT
	fiche
	, codePerm AS code_perm
FROM
    {{ var("database_jade") }}.dbo.e_ele