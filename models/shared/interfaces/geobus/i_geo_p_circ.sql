SELECT 
    annee
    ,simul ----always filter by 0 as the internal css full version of the data
    --,idcirc
    ,NoCirc as no_circ
    ,Nom as nom_circ

FROM 
    {{ var("database_geobus") }}.dbo.GEO_P_CIRC