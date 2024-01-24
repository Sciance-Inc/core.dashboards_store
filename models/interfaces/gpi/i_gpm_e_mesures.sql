select fiche, id_eco, type_mesure, date_deb_mesure, date_fin_mesure
from {{ var("database_gpi") }}.dbo.gpm_e_mesures
