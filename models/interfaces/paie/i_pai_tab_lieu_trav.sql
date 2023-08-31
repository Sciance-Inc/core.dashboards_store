select descr, lieu_trav, eco_off from {{ var("database_paie") }}.dbo.pai_tab_lieu_trav
