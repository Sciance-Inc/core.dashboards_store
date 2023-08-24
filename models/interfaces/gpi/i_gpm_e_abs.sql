SELECT 
    date_abs, 
    fiche, 
    id_eco
FROM {{ var("database_gpi") }}.dbo.gpm_e_abs