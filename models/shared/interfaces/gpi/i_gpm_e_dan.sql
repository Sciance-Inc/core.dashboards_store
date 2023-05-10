SELECT 
    fiche
      , id_eco
      , grp_rep
      , statut_don_an
      , effectif
      , ordre_ens
      , classe
      , dist
      , date_deb
  FROM 
  {{ var("database_gpi") }}.dbo.gpm_e_dan