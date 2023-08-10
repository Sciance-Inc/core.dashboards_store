SELECT 
    id_eco,
    grille,
    date_evenement,
    jour_cycle
FROM {{ var("database_gpi") }}.dbo.gpm_t_cal