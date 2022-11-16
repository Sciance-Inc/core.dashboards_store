SELECT
    DESCR
    , ETAT_EMPL 
FROM
    {{ var("database_paie") }}.dbo.PAI_TAB_ETAT_EMPL
    