SELECT 
  id_obj_mat
    , id_eco
    , mat
    , obj_01
    , obj_02
    , obj_03
    , obj_04
    , descr
    , descr_abreg
    , descr_det
    , pond_obj
FROM {{ var("database_gpi") }}.dbo.gpm_t_obj_mat