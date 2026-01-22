with base as (
    select 
        filter_key as category_join_key,
        categorie,
        sum(hrs_remunere) as hrs_remunere
    from {{ ref('eff_report_paiement') }}
    group by
        filter_key,
        categorie
)

select
    category_join_key,
    categorie,
    hrs_remunere,
    cast(round(100.0 * hrs_remunere / nullif(sum(hrs_remunere * 1.0) over (partition by category_join_key), 0), 0) as integer) as prct_of_hrs_remunere
from base