SELECT 
    fiche
    , id_mat_ele
    , id_obj_mat
    , res_final_obj
    , res_obj_01
    , res_obj_02
    , res_obj_03
    , res_obj_04
    , res_obj_05
    , res_obj_06
    , res_obj_07
    , res_obj_08
    , res_obj_09
    , res_obj_10
FROM {{ var("database_gpi") }}.dbo.gpm_e_obj