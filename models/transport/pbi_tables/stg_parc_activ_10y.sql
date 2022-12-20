SELECT distinct p.Annee
      ,CASE WHEN P.Per = 1 THEN 'AM' WHEN P.Per = 8 THEN 'PM' END AS Per 
	,P.Per AS PerNum
      ,LEFT(REPLACE(STR(p.NoParc, 5), ' ', '0'), 5) AS 'Parcours'
	,p.No_Parc 
      ,p.Nom
	,CASE WHEN p.Ind_Active = 1 THEN 'Oui' WHEN p.IndActive = 0 THEN 'No' END AS Actif
	,LEFT(REPLACE(STR(P.HreDeb, 4), ' ', '0'), 2) + ':' + RIGHT(REPLACE(STR(P.HreDeb, 4), ' ', '0'), 2) as 'Hre_debut'
      ,p.No_Circ as Circuit
      ,p.Nb_Place as Capacite
	,p.Nb_Rang
	,p.Duree as "Duree_sec"
      ,p.Dist_Tot as "Dist_m"
	,p.Dist_Impro
	,p.Date_Modif_Par_Attrib  as "Maj_attribution"
  FROM {{ ref('i_geobus_parc') }} as p
  where p.Ind_Active = 1  and p.Dist_Tot > 0 and p.Duree > 0 and p.simul = 0
  and p.Annee >=  YEAR(GETDATE())-10
