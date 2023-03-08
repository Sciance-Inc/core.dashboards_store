{{ config(alias='emp65_ann_bdgtr') }}
SELECT 
    annee_budgetaire
    , COUNT(matr) as number_of_permanent_employee
    , SUM(CONVERT(numeric(10,0),(CASE WHEN age_ann_bdgtr = 65  THEN 1 ELSE 0 END))) AS number_of_permanent_employee_65_years_old
    , CONVERT(numeric(10,10),AVG(CASE WHEN age_ann_bdgtr = 65 AND MONTH(date_nais) > 7 THEN 1.0 ELSE 0.0 END)) AS proportion_of_permanent_employee_65_years_old
FROM {{ ref('prspctf_fact_hemp_post_permanant_age') }} 
WHERE annee_budgetaire >= YEAR(GETDATE()) - 5
GROUP BY annee_budgetaire
