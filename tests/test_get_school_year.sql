{% set start_month = var("school_year_start_month", 9) %}

with
    cases as (
        select datefromparts(2024, {{ start_month }}, 1) as date_, 2024 as expected
        union all
        select
            dateadd(month, -1, datefromparts(2024, {{ start_month }}, 1)) as date_,
            2023 as expected
    )

select *
from cases
where {{ core_dashboards_store.get_school_year("date_") }} != expected
