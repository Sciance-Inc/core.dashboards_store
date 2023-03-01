SELECT
    stat_eng
    ,descr AS descr_stat_eng
FROM
    {{ var("database_paie") }}.dbo.pai_tab_stat_eng