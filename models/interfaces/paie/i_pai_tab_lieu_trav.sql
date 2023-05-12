SELECT
    DESCR
    , LIEU_TRAV
    , ECO_OFF
FROM
    {{ var("database_paie") }}.dbo.pai_tab_lieu_trav 