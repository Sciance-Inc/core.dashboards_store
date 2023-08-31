{{ config(alias="report_ratio_anc") }}

select annee_budgetaire, avg(cast(anc_2ans as float)) as ratio_anc
from {{ ref("prspctf_fact_anc_2y") }}

group by annee_budgetaire
