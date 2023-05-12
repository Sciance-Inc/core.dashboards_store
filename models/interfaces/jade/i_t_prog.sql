SELECT
	prog
	, progMeq AS prog_meq
	, descrProg AS descr_prog
FROM
    {{ var("database_jade") }}.dbo.t_prog