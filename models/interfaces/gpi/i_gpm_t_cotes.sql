select id_eco, id_cote, cote, leg, note_equiv, indic_reus_echec
from {{ var("database_gpi") }}.dbo.gpm_t_cotes
