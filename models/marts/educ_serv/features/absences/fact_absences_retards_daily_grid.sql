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
{{
    config(
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["fiche", "id_eco", "date_abs"]
            ),
        ]
    )
}}

with
    -- OVERRIDE THE dim_absences_grid TABLE TO MANUALLY CONTROL THE NUMBER OF PERIODES
    -- PER GRID AND
    -- SCHOOL, OR TO EXCLUDE SOME SCHOOLS / YEAR FROM THE COMPUTATION
    grid as (
        select * from {{ ref("dim_cal_eco_grid") }} where jour_cycle is not null  -- Only keep working days
    )

select
    src.date_abs,
    src.fiche,
    src.id_eco,
    src.grille,
    src.is_absence,
    src.n_periods_events,
    grid.n_periods_expected,
    src.event_description,
    src.n_periods_events
    * 100.0
    / grid.n_periods_expected as prct_observed_periods_over_expected,
    -- Categorize the events based on : full-day / partial and absence / retard
    -- By construyction , the category is not nullable. The null case is
    -- outputed as test hook.
    case
        when src.n_periods_events >= grid.n_periods_expected  -- Schould logically be a strict = but a few students have more event than expected periods
        then
            case
                when src.is_absence = 1
                then 'absence (journée complète)'
                when src.is_absence = 0
                then 'retard (journée complète)'
                else null
            end
        when src.n_periods_events < grid.n_periods_expected
        then
            case
                when src.is_absence = 1
                then 'absence (période)'
                when src.is_absence = 0
                then 'retard (période)'
                else null
            end
        else null
    end as event_kind
from {{ ref("fact_absences_retards_daily_src") }} as src
join
    grid
    on src.id_eco = grid.id_eco
    and src.date_abs = grid.date_evenement
    and src.grille = grid.grille
where grid.n_periods_expected > 0  -- If no period is expected then we can't compute an absence rate.
