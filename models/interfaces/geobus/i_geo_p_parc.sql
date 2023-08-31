select
    annee,
    per,  -- - period AM and PM
    idparc,  -- key id  connect to i_geo_e_ele_trsp_parc
    simul,  -- - 0                                 
    noparc as no_parc,
    nom as nom_parc,
    indactive as ind_active,  -- active/inactive                                                       
    -- , IndAvisTransp AS ind_avis_transp
    nocirc as no_circ
from {{ var("database_geobus") }}.dbo.geo_p_parc
