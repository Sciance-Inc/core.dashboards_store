SELECT
    DESCR
    , LIEU_TRAV
FROM
    {{ var("database_paie") }}.dbo.pai_tab_lieu_trav 