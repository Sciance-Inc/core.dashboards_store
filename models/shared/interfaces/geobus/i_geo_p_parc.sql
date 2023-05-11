
SELECT annee                                    
  , per  --- period AM and PM
  , idparc --key id  connect to i_geo_e_ele_trsp_parc
  , simul    --- 0                                 
  , NoParc AS no_parc                               
  , nom as nom_parc                                     
  , IndActive AS ind_active                         -- active/inactive                                                       
  --, IndAvisTransp AS ind_avis_transp
  , NoCirc AS no_circ                               
  FROM 
    {{ var("database_geobus") }}.dbo.geo_p_parc