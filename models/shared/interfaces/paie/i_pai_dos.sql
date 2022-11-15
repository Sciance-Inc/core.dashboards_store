SELECT
    matr
    , date_entr
    , lieu_trav
    , stat_eng
FROM
    {{ var("database_paie") }}.dbo.pai_dos_empl