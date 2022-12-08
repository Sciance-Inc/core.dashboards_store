SELECT
	code
    , cf_descr
    , nom_table
FROM
    {{ var("database_jade") }}.dbo.wl_descr