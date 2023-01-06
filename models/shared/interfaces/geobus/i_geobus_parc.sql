
SELECT 
  Annee AS annee                                    -- parcours rapport
  , Per AS per                                      -- parcours rapport
  , NoParc AS no_parc                               -- parcours rapport
  , Nom AS nom                                      -- parcours rapport
  , IndActive AS ind_active                         -- active/not active for today
  , NbRang  AS nb_rang                              -- for Circuits rapport
  , DistTot AS dist_tot                             -- financ
  , Duree AS duree                                  -- financ
  , NbPlace AS nb_place                             -- circuits rapp
  , IndAvisTransp AS ind_avis_transp
  , NoCirc AS no_circ                               -- parcour rapport
  , NoSeqTrt AS no_seq_trt                          -- parcour rapport
  , HreDeb AS hre_deb                               -- financ rapport
  , DistImpro AS dist_impro
  , DureeImpro AS duree_impro                       -- duration sec. for finansial calculation
  , DateModifParAttrib AS date_modif_par_attrib     -- this date include in the parcoure rapport in a geobus app
  FROM 
    {{ var("database_geobus") }}.dbo.GEO_P_PARC