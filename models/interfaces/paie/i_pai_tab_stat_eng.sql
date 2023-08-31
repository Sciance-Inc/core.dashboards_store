select stat_eng, descr as descr_stat_eng
from {{ var("database_paie") }}.dbo.pai_tab_stat_eng
