SELECT
    DESCR
    , CORP_EMPL 
FROM
    {{ var("database_paie") }}.dbo.pai_tab_corp_empl 
