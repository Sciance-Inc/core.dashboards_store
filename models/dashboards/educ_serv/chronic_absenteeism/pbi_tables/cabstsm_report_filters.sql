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
    Gather all the filters into one table to allow for between-pages corss filtering.
#}
{{ config(alias="report_absences_filters") }}

-- Select all the schools / year  we have data for with respect to a 10 years time
-- frame.
with
    eco as (
        select eco, id_eco, annee as school_year, school_friendly_name
        from {{ ref("dim_mapper_schools") }}
        where
            annee
            between {{ core_dashboards_store.get_current_year() - 10 }}
            and {{ core_dashboards_store.get_current_year() }}

    -- Select all the distinct population we have data for
    ),
    popu as (select distinct population from {{ ref("spine") }}),

    -- Select all the distinct event_kind we have data for 
    cat as (select distinct event_kind from {{ ref("fact_absences_retards_sequence") }})

-- Create the composite filter key
select
    eco.school_friendly_name,
    convert(date, concat(eco.school_year, '-09-1'), 102) as school_year,
    popu.population,
    cat.event_kind as category,
    {{
        dbt_utils.generate_surrogate_key(
            ["eco.eco", "eco.school_year", "popu.population", "cat.event_kind"]
        )
    }} as filter_key,
    -- RLS hook
    eco.id_eco,
    eco.eco
from eco as eco
cross join popu as popu
cross join cat as cat
where
    eco.eco is not null
    and eco.school_friendly_name is not null
    and popu.population is not null
    and eco.school_year is not null
