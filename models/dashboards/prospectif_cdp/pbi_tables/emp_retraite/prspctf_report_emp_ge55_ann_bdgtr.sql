{{ config(alias="report_emp_ge55_ann_bdgtr") }}
select
    annee_budgetaire,
    count(matr) as number_of_permanent_employee,
    sum(
        convert(numeric(10, 0), (case when age_ann_bdgtr >= 55 then 1 else 0 end))
    ) as number_of_permanent_employee_ge55_years_old,
    convert(
        numeric(10, 10),
        avg(
            case when age_ann_bdgtr >= 55 and month(date_nais) > 7 then 1.0 else 0.0 end
        )
    ) as proportion_of_permanent_employee_ge55_years_old
from {{ ref("prspctf_fact_hemp_post_permanant_age") }}
where annee_budgetaire >= year(getdate()) - 5
group by annee_budgetaire
