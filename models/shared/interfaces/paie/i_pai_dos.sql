SELECT
    matr
    , date_entr
    , lieu_trav
    , stat_eng
    , ref_empl
    , corp_empl
    , etat
    , date_dern_jr_trav
    , CASE 
		WHEN month([date_dern_jr_trav]) < 7 THEN CONCAT(year([date_dern_jr_trav])-1, year([date_dern_jr_trav]))
		ELSE CONCAT(year([date_dern_jr_trav]), year([date_dern_jr_trav]) +1)
	  END as annee_budgetaire
FROM
    {{ var("database_paie") }}.dbo.pai_dos_empl
