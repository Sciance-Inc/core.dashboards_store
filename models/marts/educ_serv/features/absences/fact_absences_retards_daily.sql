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
	Compute the number of absences and delay for each students by day of absence / delay.
    Events are further qualified by the number of periods impacted (full day / partial day).
    Each absence is mapped to the student's etape.

#}
{{
    config(
        post_hook=[
            store.create_clustered_index(
                "{{ this }}", ["fiche", "id_eco", "school_year"]
            ),
            store.create_nonclustered_index("{{ this }}", ["fiche"]),
        ]
    )
}}

{% set max_periodes = var("interfaces")["gpi"]["max_periodes"] + 1 %}

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
    ),
    src_with_grid_id as (
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
            {{ ref("i_gpm_e_dan") }} as dan
            on src.fiche = dan.fiche
            and src.id_eco = dan.id_eco

    -- Pre compute the expected daily number of periods per grid : later used to split
    -- days between the day of complete absence, and day of partial absence
    ),
    grid as (
        select
            id_eco,
            date_evenement,
            grille,
            {% for i in range(1, max_periodes) %}
                case when max(per_{{ "%02d" % i }}) is null then 0 else 1 end
                {%- if not loop.last %} +{% endif -%}
            {% endfor %} as n_periods_expected
        from {{ ref("i_gpm_t_cal") }}
        where jour_cycle is not null  -- Only keep working days
        group by id_eco, date_evenement, grille

    -- Add the expected number of periods to the observed events
    ),
    src_with_expected_periodes as (
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
        from src_with_grid_id as src
        join
            grid
            on src.id_eco = grid.id_eco
            and src.date_abs = grid.date_evenement
            and src.grille = grid.grille
        where grid.n_periods_expected > 0  -- If no period is expected then we can't compute an absence rate.

    -- Add a 'tous types' category
    ),
    rolledup as (
        select
            case
                when month(date_abs) <= 7 then year(date_abs) - 1 else year(date_abs)
            end as school_year,
            date_abs,
            fiche,
            id_eco,
            max(grille) as grille,  -- dymmy aggregation. Already controlled by the tuple (id_eco, fiche)
            coalesce(event_kind, 'tous types') as event_kind,
            case when event_kind is null then 1 else 0 end as is_aggregate_kind,  -- To flag the 'tous types' category
            -- By additivity of absences / retards : two differents events can't be
            -- registered for the same period
            case
                when event_kind is null then null else min(is_absence)
            end as is_absence,
            case
                when event_kind is null then 'tous types' else min(event_description)
            end as event_description,  -- arbitrary : first description in lexicographic order
            sum(
                prct_observed_periods_over_expected
            ) as prct_observed_periods_over_expected
        from src_with_expected_periodes
        group by date_abs, fiche, id_eco, rollup (event_kind)  -- Superseed is_absence

    -- Handle the weird case where 0.0001% of students have more observed periods of
    -- absences than
    -- expected periods
    ),
    corrected as (
        select
            school_year,
            date_abs,
            fiche,
            id_eco,
            grille,
            event_kind,
            is_aggregate_kind,
            is_absence,
            event_description,
            case
                when prct_observed_periods_over_expected > 100.0
                then 100.0
                else prct_observed_periods_over_expected
            end as prct_observed_periods_over_expected
        from rolledup
    )

-- Add the etape
select
    src.school_year,
    src.date_abs,
    src.fiche,
    src.id_eco,
    src.grille,
    src.event_kind,
    src.is_aggregate_kind,
    src.is_absence,
    src.event_description,
    src.prct_observed_periods_over_expected,
    etp.etape,
    etp.etape_description,
    etp.seq_etape
from corrected as src
left join
    {{ ref("stg_fact_fiche_etapes") }} as etp
    on src.fiche = etp.fiche
    and src.id_eco = etp.id_eco
    and src.date_abs between etp.date_debut and etp.date_fin
