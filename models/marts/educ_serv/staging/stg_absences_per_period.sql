{#
	This (sparse) table compute the number of absence periods per day and per students, for every student with at least one absence on a given day.
#}

SELECT 
	CASE         
        WHEN MONTH(date_abs) <= 7 THEN YEAR(date_abs) - 1 
        ELSE YEAR(date_abs)
    END AS school_year,
	date_abs,
	fiche,
	id_eco,
	COUNT(*) AS n_periods_of_absence
FROM {{ ref('i_gpm_e_abs') }}
GROUP BY 
	date_abs,
	fiche,
	id_eco