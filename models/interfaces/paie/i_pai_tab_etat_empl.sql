SELECT
    DESCR
    , ETAT_EMPL 
FROM
    {{ var("database_paie") }}.dbo.pai_tab_etat_empl 
    