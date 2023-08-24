{{ config(alias='fact_anc_2y') }}

WITH 
src AS (
SELECT 
		hempl.matr
      , hempl.date_eff
      , hempl.etat
FROM {{ ref('i_paie_hemp') }} AS hempl

WHERE  hempl.type = 'A'
),	

--Check if the user left the CSS
bool AS (
SELECT 
	*,
	CASE WHEN etat NOT LIKE 'C%' THEN 0 ELSE 1 END AS hasleft 
FROM src
),

--Check the column hasleft if the employe is back during the current year
lagged AS (
SELECT
	*,
	LAG(hasleft, 1, 0) OVER (PARTITION BY matr ORDER BY date_eff) AS hasleftlagged 
FROM bool
),

--Start a new periode once the employee is back in the cssxx
start_ AS (
SELECT 
	*,
	CASE WHEN hasleftlagged != hasleft AND hasleftlagged = 1 THEN 1 ELSE 0 END AS periodestart
FROM lagged
),

 --Distinct the number of period the employee has
partition AS (
SELECT 
	*,
	SUM(periodeStart) OVER (PARTITION BY matr ORDER BY date_eff ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS partitionId
	FROM start_
),

--Min date of each employee
calc_date AS (
SELECT 
	*
	, MIN(date_eff) OVER (PARTITION BY matr) AS min_date 
	FROM partition
	GROUP BY matr, date_eff,etat, hasleft, hasleftlagged, periodestart, partitionid

),
date_diff AS (

	SELECT
		matr
		, CASE WHEN MONTH(date_eff) < 7 THEN YEAR(date_eff) - 1
				ELSE YEAR(date_eff)
			END AS annee_budgetaire
		, DATEDIFF(DAY,min_date,MAX(date_eff)) AS delta_day --Total of day the employee has been active
		, MAX(partitionId) AS periode
	FROM calc_date
	GROUP BY date_eff, matr, min_date
),

sequence_id AS (

SELECT
	matr
	, annee_budgetaire
	, delta_day
	, periode
	, ROW_NUMBER() OVER (PARTITION BY matr, annee_budgetaire, periode ORDER BY annee_budgetaire asc) AS seqid
	FROM date_diff
),

anciennete AS (

SELECT
	*
	, CASE WHEN delta_day >= 730 THEN 1 ELSE 0 -- 2 yrs
	END AS anc_2ans
	FROM sequence_id
	WHERE seqid = 1
		AND annee_budgetaire BETWEEN {{  store.get_current_year() }} - 5 AND {{  store.get_current_year() }}
)
SELECT *
FROM anciennete


