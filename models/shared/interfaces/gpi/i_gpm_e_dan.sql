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
      , plan_interv_ehdaa
      , difficulte
      , cycle_ref
      , annee_cycle_ref
  FROM 
  {{ var("database_gpi") }}.dbo.gpm_e_dan