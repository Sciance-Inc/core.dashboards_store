SELECT DISTINCT 
      annee
      , CASE 
            WHEN per = 1 THEN 'AM' 
            WHEN per = 8 THEN 'PM' 
      END AS per 
	, per AS per_num
      , LEFT(REPLACE(STR(no_parc, 5), ' ', '0'), 5) AS parcours
	, no_parc 
      , nom
	, CASE 
            WHEN ind_active = 1 THEN 'Oui' 
            WHEN ind_active = 0 THEN 'Non' 
      END AS actif
	, LEFT(REPLACE(STR(hre_deb, 4), ' ', '0'), 2) + ':' + RIGHT(REPLACE(STR(hre_deb, 4), ' ', '0'), 2) AS hre_debut
      , no_circ AS circuit
      , nb_place AS capacite
	, nb_rang
	, duree AS duree_sec
      , dist_tot AS dist_m
	, dist_impro
	, date_modif_par_attrib AS maj_attribution
  FROM {{ ref('i_geobus_parc') }}
  WHERE 
      ind_active = 1  
      AND dist_tot > 0 
      AND duree > 0 
      AND simul = 0
      AND annee >=  YEAR(GETDATE())-10
