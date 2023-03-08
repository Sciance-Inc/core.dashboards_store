 
 {{ config(alias='fact_hemp_post_permanant_age') }}

WITH emp AS (
  SELECT
   ih.matr
   ,id.date_nais
   ,CASE 
      WHEN MONTH(ih.date_eff) < 7 THEN YEAR(ih.date_eff) - 1 
        ELSE YEAR(ih.date_eff)  
      END AS annee_budgetaire 

  FROM  {{ ref('i_paie_hemp') }}  AS ih
      LEFT JOIN {{ ref('i_pai_dos') }}  AS id ON (ih.matr = id.matr)
      JOIN {{ adapt('employees_status','cstmrs_stat_eng') }} AS se ON (se.stat_eng = ih.stat_eng) --a seed from the clients css

WHERE se.stat_st = 1 ---all posts permanant 

), em2 as (
SELECT 
    matr
    ,annee_budgetaire
    ,date_nais
    ,CASE 
      WHEN MONTH(date_nais) > 7 THEN annee_budgetaire - YEAR(date_nais) + 1 
        ELSE annee_budgetaire - YEAR(date_nais) 
    END AS age_ann_bdgtr -- July 1 - sturt of the academic/financial year
 /*   , CASE 
      WHEN MONTH(date_nais) > 7 THEN 1  
        ELSE 0 END AS 65an_ann_bdgtr*/
FROM emp

)
select 
    matr
    ,date_nais
    ,annee_budgetaire
    ,age_ann_bdgtr
from em2 
GROUP BY matr
    ,date_nais
    ,annee_budgetaire
    ,age_ann_bdgtr
