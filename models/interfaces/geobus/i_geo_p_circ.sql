select
    annee,
    simul,  -- --always filter by 0 as the internal css full version of the data
    -- ,idcirc
    nocirc as no_circ,
    nom as nom_circ

from {{ var("database_geobus") }}.dbo.geo_p_circ
