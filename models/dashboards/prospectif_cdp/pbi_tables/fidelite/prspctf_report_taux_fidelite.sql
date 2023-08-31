{{ config(alias="report_taux_fidelite") }}

select
    annee_budgetaire,
    1 - (
        cast(
            cast(sum(demission_volontaire) as float)
            / cast(count(demission_volontaire) as float) as decimal(5, 5)
        )
    ) as 'ratio_fidelisation'
from {{ ref("prspctf_fact_demission") }}

group by annee_budgetaire
