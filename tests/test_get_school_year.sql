{#
Dashboards Store - Helping students, one dashboard at a time.
Copyright (C) 2023  Sciance Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
#}
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
