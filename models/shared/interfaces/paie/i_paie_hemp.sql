SELECT
    matr
    , date_eff
    , lieu_trav
    , corp_empl
    , etat
    , stat_eng
FROM
    {{ var("database_paie") }}.dbo.pai_hemp