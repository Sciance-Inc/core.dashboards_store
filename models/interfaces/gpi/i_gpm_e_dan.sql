SELECT 
    fiche
    , id_eco
    , cycle_ref
    , annee_cycle_ref
    , grp_rep
    , statut_don_an
    , effectif
    , ordre_ens
    , classe
    , dist
    , date_deb
    , plan_interv_ehdaa
    , difficulte
  FROM {{ var("database_gpi") }}.dbo.gpm_e_dan