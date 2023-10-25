select id_eco, mat, descr, descr_abreg from {{ var("database_gpi") }}.dbo.gpm_t_mat
