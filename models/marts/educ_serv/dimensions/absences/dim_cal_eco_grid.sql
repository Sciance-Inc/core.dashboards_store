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
-- This table is to be overwridden to manually control the number of periodes per grid
-- and school.
-- This table can also be used to EXLUDE some schools / year from the computation.
{{
    config(
        post_hook=[
            core_dashboards_store.create_clustered_index("{{ this }}", ["id_eco"]),
        ]
    )
}}

{% set max_periodes = var("interfaces")["gpi"]["max_periodes"] + 1 %}

select
    id_eco,
    date_evenement,
    grille,
    jour_cycle,
    {% for i in range(1, max_periodes) %}
        case when max(per_{{ "%02d" % i }}) is null then 0 else 1 end
        {%- if not loop.last %} +{% endif -%}
    {% endfor %} as n_periods_expected
from {{ ref("i_gpm_t_cal") }}
group by id_eco, date_evenement, grille
