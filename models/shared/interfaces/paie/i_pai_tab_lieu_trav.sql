SELECT
    DESCR
    , LIEU_TRAV
FROM
    {{ var("database_paie") }}.dbo.PAI_TAB_LIEU_TRAV