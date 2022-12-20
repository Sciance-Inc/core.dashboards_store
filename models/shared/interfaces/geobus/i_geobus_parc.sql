
SELECT Annee --parcour rapport
      ,Per --parcour rapport
      ,NoParc AS No_Parc --parcour rapport
      ,Nom --parcour rapport
      ,IndActive AS Ind_Active-- active/not active for today
      ,NbRang  AS Nb_Rang Nb-- for Circuits rapport
      ,DistTot AS Dist_Tot--financ
      ,Duree  --financ
      ,NbPlace AS Nb_Place--circuits rapp
      ,IndAvisTransp AS Ind_Avis_Transp
      ,NoCirc AS No_Circ--parcour rapport
      ,NoSeqTrt AS No_Seq_Trt-- parcour rapport
      ,HreDeb AS Hre_Deb -- financ rapport
      ,DistImpro AS Dist_Impro --
      ,DureeImpro AS Duree_Impro  --duration sec. for finansial calculation
      ,DateModifParAttrib AS Date_Modif_Par_Attrib-- this date include in the parcoure rapport in a geobus app
  FROM 
    {{ var("database_geobus") }}.dbo.GEO_P_PARC