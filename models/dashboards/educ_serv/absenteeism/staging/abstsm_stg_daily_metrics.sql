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
    Compute the backfilled and padded version of the daily number of students and absences
    Backfilled is done by / etape.
    Padding is needed to properly aggregate absences rate : if no absences has been recorded for a given day, the absences rate should be 0.
    Padding is done by / etape, / grille, / id_eco, / date_evenement, / event_kind to accound for various grid per school and allow number of aggregation leves
#}
{{
    config(
        alias="stg_daily_absences_rate",
        post_hook=[
            store.create_clustered_index(
                "{{ this }}", ["annee", "school_friendly_name", "date_evenement"]
            ),
            store.create_nonclustered_index("{{ this }}", ["date_evenement"]),
        ],
    )
}}


-- Aggregate the number of absences / retards so it can be joined with the daily metrics
with
    abs_aggregated as (
        select
            date_abs as date_evenement,
            id_eco,
            grille,
            case when etape in ('1', '2', '3') then etape else 0 end as etape,  -- Map the etape to the same kind of values as the ones from the daily students
            event_kind,
            count(distinct fiche) as n_events
        from {{ ref("fact_absences_retards_daily") }}
        group by
            date_abs,
            id_eco,
            grille,
            case when etape in ('1', '2', '3') then etape else 0 end,
            event_kind

    -- Combine the number of absences with the daily number of students (padded and
    -- backfilled)
    ),
    augmented as (
        select
            padd.id_eco,
            padd.date_evenement,
            padd.grille,
            padd.event_kind,
            padd.etape,
            padd.n_students_daily,
            coalesce(abs_.n_events, 0) as n_events
        from {{ ref("abstsm_stg_padding") }} as padd
        left join
            abs_aggregated as abs_
            on padd.id_eco = abs_.id_eco
            and padd.date_evenement = abs_.date_evenement
            and padd.grille = abs_.grille
            and padd.etape = abs_.etape
            and padd.event_kind = abs_.event_kind
        where padd.is_school_day = 1

    -- Get rid of the grille dimensions, add add the school friendly name
    ),
    aggregated as (
        select
            id_eco,
            date_evenement,
            etape,
            event_kind,
            -- By orthogonality of the grids (ath the time the ETL run, one student as
            -- only one grid.)
            sum(n_events) as n_events,
            sum(n_students_daily) as n_students_daily
        from augmented as aug
        group by id_eco, date_evenement, etape, event_kind

    -- Compute the absence rate
    ),
    rate as (
        select
            id_eco,
            date_evenement,
            etape,
            event_kind,
            n_events,
            n_students_daily,
            case
                when n_students_daily = 0 then 0. else n_events * 1.0 / n_students_daily
            end as absence_rate
        from aggregated
        where n_students_daily > 0  -- Avoid division by 0

    -- Handle the smôôôôl percentage of degenerates cases, and reformat the dimensions
    ),
    corrected as (
        select
            id_eco,
            date_evenement,
            case
                when etape = 0 then 'inconnue' else cast(etape as varchar)
            end as etape_friendly,
            event_kind,
            n_events,
            n_students_daily,
            case when absence_rate > 1. then 1. else absence_rate end as absence_rate
        from rate
    )

select
    annee,
    school_friendly_name,
    date_evenement,
    concat('étape : ', etape_friendly) as etape_friendly,
    event_kind,
    n_events,
    n_students_daily,
    absence_rate
from corrected as src
left join {{ ref("dim_mapper_schools") }} as eco on src.id_eco = eco.id_eco
