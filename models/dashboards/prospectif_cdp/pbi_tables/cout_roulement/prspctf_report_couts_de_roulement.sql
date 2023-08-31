{{ config(alias="report_couts_de_roulement") }}

with
    src as (
        select msce.*, emoq.nb_empl_aremp
        from {{ ref("prspctf_fact_masse_sal_corp_empl") }} as msce
        left join
            {{ ref("prspctf_fact_emp_quitter") }} as emoq
            on msce.annee_budgetaire = emoq.annee_budgetaire
            and msce.corp_empl = emoq.corp_empl
    ),
    agg as (
        select
            annee_budgetaire,
            case
                when annee_budgetaire = {{ store.get_current_year() }}
                then lag(masse_salariale_an) over (order by annee_budgetaire asc)
                else masse_salariale_an
            end as masse_salariale_an,
            sum(sal_moy_corp_emp * nb_empl_aremp) as couts_de_roulement

        from src
        group by annee_budgetaire, masse_salariale_an
    )
select
    annee_budgetaire,
    cast(
        ((couts_de_roulement / masse_salariale_an)) as decimal(5, 5)
    ) as ratio_couts_roulement
from agg
