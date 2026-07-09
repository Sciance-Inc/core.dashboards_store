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
    -- Extract all the qualified absences / retards
    src as (
        select
            fct.date_abs,
            fct.fiche,
            fct.id_eco,
            coalesce(dim.is_absence, 1) as is_absence,  -- Default to 0 if the absence is not qualified (prefer false positive over false negative)
            count(*) as n_periods_events,
            coalesce(min(dim.description_abs), 'inconnue') as event_description  -- Take the first one, in lexicographic order. It's completely arbitrary ;) A better proxy would be the most common occurence
        from {{ ref("i_gpm_e_abs") }} as fct
        inner join
            {{ ref("stg_dim_absences_retards_inclusion") }} as dim
            on fct.id_eco = dim.id_eco
            and fct.motif_abs = dim.motif_abs
        group by fct.date_abs, fct.fiche, fct.id_eco, dim.is_absence

    -- Add the calendar grille the student follows from the DAN
    )

select
    src.date_abs,
    src.fiche,
    src.id_eco,
    dan.grille,
    src.is_absence,
    src.n_periods_events,
    src.event_description
from src
join
    {{ ref("i_gpm_e_dan") }} as dan on src.fiche = dan.fiche and src.id_eco = dan.id_eco
