select matr, ref_empl, date_eff, lieu_trav, pourc_lieu_trav
from {{ var("database_paie") }}.dbo.pai_hemp_lieu_trav_sec
