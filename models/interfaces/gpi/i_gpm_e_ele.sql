SELECT 
    fiche
    , code_perm
    , sexe
FROM {{ var("database_gpi") }}.dbo.gpm_e_ele