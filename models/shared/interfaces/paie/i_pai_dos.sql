SELECT
    matr
    , nom_legal
    , date_nais
    , date_deb_serv
    , date_fin_serv 
FROM
    {{ var("database_paie") }}.dbo.pai_dos