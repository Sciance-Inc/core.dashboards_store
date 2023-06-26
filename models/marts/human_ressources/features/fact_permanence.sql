{{ config(alias='fact_permanence') }}
-- Get all information needed
WITH stepOne AS (
	SELECT 
		EMP.MATR
		, EMP.DATE_ENTR
		, seedEtat.etat_actif
		, CASE WHEN -- Active employment
			IND_EMPL_PRINC = 1 
		THEN
			CAST( GETDATE() AS Date) --Current date
		ELSE
			EMP.DATE_EFF -- End of employment day
		END AS DATE_FIN
		, EMP.ETAT
		, EMP.STAT_ENG
		, IND_EMPL_PRINC
		, CORP_EMPL
	from {{ ref('i_pai_dos_empl') }} EMP
	LEFT JOIN {{ ref('etat_empl') }} seedEtat ON EMP.ETAT = seedEtat.ETAT_EMPL
	LEFT JOIN {{ ref('stat_eng') }} seedStatusEng ON EMP.STAT_ENG = seedStatusEng.STAT_ENG
	WHERE 
		seedStatusEng.is_reg = 1 -- Only employees who are regular
		AND seedEtat.etat_actif = 1  -- Only employees who are actives
),

-- Get the current job
mainJob  AS (
	SELECT 
		stepOne.MATR
		, stepOne.CORP_EMPL
	FROM stepOne
	WHERE IND_EMPL_PRINC = 1
),

-- Get all experiences wich has the same job group
experience  AS (
	SELECT 
	exp.MATR
	, exp.CORP_EMPL
	, CASE WHEN -- Active employment
		exp.etat_actif = 1  
		AND exp.STAT_ENG LIKE '%1' 
		AND IND_EMPL_PRINC = 1 
	THEN
		DATEDIFF(dd, exp.DATE_ENTR, CAST( GETDATE() AS Date))/365.0 -- Datediff with the current date
	ELSE
		DATEDIFF(dd, exp.DATE_ENTR, exp.DATE_FIN)/365.0 -- Datediff with the end of employment day
	END AS rangeDate
	FROM stepOne exp
	LEFT JOIN mainJob ON exp.MATR = mainJob.MATR
	WHERE LEFT(exp.CORP_EMPL, 1) = LEFT(mainJob.CORP_EMPL,1)	
),

-- Sums of all experiences
sumExp AS 
(SELECT 
	 experience.MATR 
	, mainJob.CORP_EMPL
	, SUM( rangeDate) AS nbrYears
	FROM experience
	LEFT JOIN mainJob 
	ON experience.MATR = mainJob.MATR
	GROUP BY experience.matr, mainJob.CORP_EMPL
)

-- Display only the value required
select 
	MATR AS matricule
	, CORP_EMPL AS corps_emploi
	, CASE WHEN nbrYears > 2 THEN 1 ELSE 0 END AS permanence -- if nbrYears is greater than 2 then the employee as is permanence
FROM sumExp
GROUP BY matr, CORP_EMPL, nbrYears