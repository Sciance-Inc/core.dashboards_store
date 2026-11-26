select matr, ref_empl, corp_empl, etat, date_eff, date_fin, lieu_trav, pourc_lieu_trav
from {{ var("database_paie") }}.dbo.pai_hemp
