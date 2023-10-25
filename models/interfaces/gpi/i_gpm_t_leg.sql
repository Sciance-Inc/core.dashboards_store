select id_eco, leg, seuil_reus from {{ var("database_gpi") }}.dbo.gpm_t_leg
