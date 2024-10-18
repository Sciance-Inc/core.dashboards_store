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
{#
    Shadow the fact table to extract the abseentees for the current year
#}
{{ config(alias="report_absences_listing") }}

select
    {{
        dbt_utils.generate_surrogate_key(
            ["eco.eco", "src.school_year", "spi.population", "src.event_kind"]
        )
    }} as filter_key,
    spi.fiche,
    eco.eco,
    bra.name as bracket_name,
    src.event_start_date as absence_start_date,
    src.events_sequence_length as absences_sequence_length,
    src.last_event_description as last_description_abs
from {{ ref("fact_absences_retards_sequence") }} as src
left join {{ ref("dim_mapper_schools") }} as eco on src.id_eco = eco.id_eco
inner join
    {{ ref("spine") }} as spi
    on src.fiche = spi.fiche
    and eco.eco = spi.eco
    and src.school_year = spi.annee
    and spi.seqid = 1
inner join
    {{ ref("repartition_brackets") }} as bra
    on src.events_sequence_length >= bra.lower_bound
    and src.events_sequence_length < bra.upper_bound
where
    src.school_year
    between {{ core_dashboards_store.get_current_year() }}
    - 1 and {{ core_dashboards_store.get_current_year() }}  -- Fetch the last two years
