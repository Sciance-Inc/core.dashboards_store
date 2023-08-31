{{ config(alias="fact_hemp_post_permanant_age") }}

with
    emp as (
        select
            ih.matr,
            id.date_nais,
            case
                when month(ih.date_eff) < 7
                then year(ih.date_eff) - 1
                else year(ih.date_eff)
            end as annee_budgetaire

        from {{ ref("i_paie_hemp") }} as ih
        left join {{ ref("i_pai_dos") }} as id on (ih.matr = id.matr)
        join {{ ref("stat_eng") }} as se on (se.stat_eng = ih.stat_eng)  -- a seed from the clients css

        where se.is_reg = 1  -- -all posts permanant 

    ),
    em2 as (
        select
            matr,
            annee_budgetaire,
            date_nais,
            case
                when month(date_nais) > 7
                then annee_budgetaire - year(date_nais) + 1
                else annee_budgetaire - year(date_nais)
            end as age_ann_bdgtr  -- July 1 - sturt of the academic/financial year
        /*   , CASE 
      WHEN MONTH(date_nais) > 7 THEN 1  
        ELSE 0 END AS 65an_ann_bdgtr*/
        from emp

    )
select matr, date_nais, annee_budgetaire, age_ann_bdgtr
from em2
group by matr, date_nais, annee_budgetaire, age_ann_bdgtr
