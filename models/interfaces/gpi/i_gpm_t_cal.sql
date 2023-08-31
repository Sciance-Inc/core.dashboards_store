select id_eco, grille, date_evenement, jour_cycle
from {{ var("database_gpi") }}.dbo.gpm_t_cal
