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
with
    base as (
        select
            filter_key as category_join_key,
            categorie,
            sum(hrs_remunere) as hrs_remunere
        from {{ ref("eff_report_paiement") }}
        group by filter_key, categorie
    )

select
    category_join_key,
    categorie,
    hrs_remunere,
    cast(
        round(
            100.0
            * hrs_remunere
            / nullif(sum(hrs_remunere * 1.0) over (partition by category_join_key), 0),
            0
        ) as integer
    ) as prct_of_hrs_remunere
from base
