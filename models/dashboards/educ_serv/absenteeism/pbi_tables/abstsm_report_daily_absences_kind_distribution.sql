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
    Compute the distribution of the daily absences splitted down by absence's kind.
#}
{{ config(alias="report_daily_absences_kind_distribution") }}

with
    abs_aggregated as (
        select
            date_abs as date_evenement,
            id_eco,
            grille,
            case when etape in ('1', '2', '3') then etape else 0 end as etape,  -- Map the etape to the same kind of values as the ones from the daily students
            event_kind,
            event_description,
            count(fiche) as n_events
        from {{ ref("fact_absences_retards_daily") }}
        where
            school_year >= {{ store.get_current_year() }} - 1  -- Only consider the last 2 years
            and is_aggregate_kind = 0  -- Do not consider the aggregated type
        group by
            date_abs,
            id_eco,
            grille,
            case when etape in ('1', '2', '3') then etape else 0 end,
            event_kind,
            event_description

    -- Create a variation of the padding table without the etape 
    ),
    padding as (
        select id_eco, date_evenement, event_kind, grille
        from {{ ref("abstsm_stg_padding") }} as padd
        where padd.is_school_day = 1
        group by id_eco, date_evenement, event_kind, grille

    -- Inner join on the padding table to reduce to the work days only (so the table
    -- is not a padding table anymore)
    ),
    augmented as (
        select
            padd.id_eco,
            padd.date_evenement,
            padd.event_kind,
            event_description,
            n_events
        from padding as padd
        inner join
            abs_aggregated as abs_
            on padd.id_eco = abs_.id_eco
            and padd.date_evenement = abs_.date_evenement
            and padd.grille = abs_.grille
            and padd.event_kind = abs_.event_kind
        where abs_.n_events is not null

    -- get rid of the grille dimension
    ),
    aggregated as (
        select
            id_eco,
            date_evenement,
            event_kind,
            event_description,
            sum(n_events) as n_events
        from augmented as aug
        group by id_eco, date_evenement, event_kind, event_description
    )

select
    {{
        dbt_utils.generate_surrogate_key(
            ["eco.annee", "eco.school_friendly_name", "event_kind"]
        )
    }} as filter_key,
    cast(date_evenement as date) as date_evenement,
    event_description,
    n_events
from aggregated as agg
left join {{ ref("dim_mapper_schools") }} as eco on agg.id_eco = eco.id_eco
