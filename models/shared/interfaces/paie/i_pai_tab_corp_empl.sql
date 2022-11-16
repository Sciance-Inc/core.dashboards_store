SELECT
    DESCR
    , CORP_EMPL 
FROM
    {{ var("database_paie") }}.dbo.PAI_TAB_CORP_EMPL
