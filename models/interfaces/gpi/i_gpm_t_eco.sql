select id_eco, org, annee, eco, cat_eco, eco_off, nom_eco, adr_eco
from {{ var("database_gpi") }}.dbo.gpm_t_eco
