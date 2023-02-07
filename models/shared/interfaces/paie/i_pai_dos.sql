SELECT
    matr
    , date_entr
    , lieu_trav
    , stat_eng
    , ref_empl
    , corp_empl
    , etat
    , date_dern_jr_trav
FROM
    {{ var("database_paie") }}.dbo.pai_dos_empl