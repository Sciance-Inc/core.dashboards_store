select descr, etat_empl from {{ var("database_paie") }}.dbo.pai_tab_etat_empl
