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
    Compute the sequence of days with at least one periode of absence.
#}
-- Extract all the days a student is expected to be there 
with
    expected_cal as (
        select
            case
                when month(date_evenement) <= 7
                then year(date_evenement) - 1
                else year(date_evenement)
            end as school_year,
            id_eco,
            grille,
            date_evenement
        from {{ ref("i_gpm_t_cal") }} as cal
        where jour_cycle is not null

    -- Add a sequence id : day_id to later identify the break between two sequences of
    -- absences
    ),
    expected_cal_with_id as (
        select
            school_year,
            id_eco,
            grille,
            date_evenement,
            row_number() over (
                partition by id_eco, grille, school_year order by date_evenement
            ) as day_id
        from expected_cal
        where date_evenement <= getdate()

    -- Left join the observed absences on the calendar
    ),
    observed as (
        select
            exp.school_year,
            exp.id_eco,
            exp.date_evenement,
            exp.day_id,
            exp.grille,
            abs.fiche,
            abs.event_kind,
            abs.event_description,
            abs.prct_observed_periods_over_expected,
            abs.etape,
            abs.etape_description,
            abs.seq_etape
        from expected_cal_with_id as exp
        inner join
            {{ ref("fact_absences_retards_daily") }} as abs
            on exp.id_eco = abs.id_eco
            and exp.date_evenement = abs.date_abs
            and exp.grille = abs.grille

    -- Get the between-sequences-of-absences breaks by checking if the previous day
    -- was a day of absence too (with respect to the event kind)
    ),
    breaks as (
        select
            school_year,
            id_eco,
            date_evenement,
            day_id,
            fiche,
            event_kind,
            event_description,
            prct_observed_periods_over_expected,
            etape,
            etape_description,
            seq_etape,
            case
                when
                    day_id - lag(day_id) over (
                        partition by school_year, id_eco, fiche, event_kind  -- No need to partition by grille, as a student (file) has only one grid (even if the school the student belongs to might have multiples grids). The fiche superseed the grid. 
                        order by day_id
                    )
                    > 1
                then 1
                else 0
            end as sequence_break
        from observed

    -- SUM over the break id to get a sequence_id
    ),
    sequences as (
        select
            school_year,
            id_eco,
            date_evenement,
            day_id,
            fiche,
            event_kind,
            event_description,
            prct_observed_periods_over_expected,
            etape,
            etape_description,
            seq_etape,
            sum(sequence_break) over (
                partition by school_year, id_eco, fiche, event_kind  -- Same rational as before regarding the grille partitioning
                order by day_id
                rows between unbounded preceding and current row
            ) as absence_sequence_id
        from breaks

    ),

    -- Select the last description_abs of each sequence to give some context. Taking
    -- the last makes more sens than taking the first, as the nature of the sequence
    -- might
    -- evolve accross time. ("Shiriû, ton avis sur la question ? C'est de la connerie.")
    contextualized as (
        select
            school_year,
            id_eco,
            date_evenement,
            day_id,
            fiche,
            event_kind,
            prct_observed_periods_over_expected,
            etape,
            etape_description,
            seq_etape,
            last_value(event_description) over (
                partition by school_year, fiche, id_eco, absence_sequence_id, event_kind
                order by day_id
                rows between unbounded preceding and unbounded following
            ) as last_event_description,
            absence_sequence_id
        from sequences

    ),

    -- Create the final table : one row per fiche X school X year X sequence of
    -- absences
    aggregated as (
        select
            school_year,
            fiche,
            id_eco,
            absence_sequence_id,
            event_kind,
            min(last_event_description) as last_event_description,  -- Dummy aggregation
            min(date_evenement) as event_start_date,
            max(date_evenement) as event_end_date,
            max(day_id) - min(day_id) + 1 as events_sequence_length,
            min(etape) as etape,  -- dummy aggregation
            min(etape_description) as etape_description,  -- dummy aggregation
            min(seq_etape) as seq_etape  -- dummy aggregation
        from contextualized
        group by school_year, fiche, id_eco, absence_sequence_id, event_kind
    )

select
    src.school_year,
    src.fiche,
    src.id_eco,
    src.event_kind,
    src.last_event_description,
    src.absence_sequence_id,
    src.event_start_date,
    src.event_end_date,
    src.events_sequence_length,
    src.etape,
    src.etape_description,
    src.seq_etape
from aggregated as src
