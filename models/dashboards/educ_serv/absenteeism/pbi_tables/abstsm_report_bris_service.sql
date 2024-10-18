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
    Identify the students who are absent for more than 8 days
#}
{{ config(alias="report_bris_service") }}

with
    src as (
        select
            fiche,
            id_eco,
            last_event_description,
            event_start_date,
            event_end_date,
            events_sequence_length,
            coalesce(etape_description, 'inconnue') as etape_description
        from {{ ref("fact_absences_retards_sequence") }}
        where
            event_kind = 'absence (journée complete)'  -- bris de service
            and events_sequence_length > 8
            and school_year = {{ core_dashboards_store.get_current_year() }}  -- Only consider the current school year

    -- Add some metadata to better identify the sutdent
    ),
    named as (
        select
            eco.school_friendly_name,
            ele.code_perm as code_permanent,
            concat(ele.nom, ' ', ele.pnom) as full_name,
            etape_description,
            event_start_date,
            event_end_date,
            events_sequence_length,
            last_event_description
        from src
        join {{ ref("i_gpm_e_ele") }} as ele on src.fiche = ele.fiche
        left join {{ ref("dim_mapper_schools") }} as eco on src.id_eco = eco.id_eco
    )

select
    school_friendly_name,
    code_permanent,
    full_name,
    etape_description,
    cast(event_start_date as date) as event_start_date,
    cast(event_end_date as date) as event_end_date,
    events_sequence_length,
    last_event_description
from named
