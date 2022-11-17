SELECT
    matr
    , date_eff
    , lieu_trav
    , CORP_EMPL
    , ETAT
FROM
    {{ var("database_paie") }}.dbo.pai_hemp