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
    Compute the etape absences rate for each students by day of absence.
    Add the CSS level metrics to ease comparison.
#}
{{ config(alias="report_etape_absences_rate") }}

with
    source as (
        select
            annee,
            school_friendly_name,
            etape_friendly,
            event_kind,
            -- The per etape absence rate is computed as the weighted average of the
            -- daily absence rate
            sum(absence_rate * n_students_daily)
            / sum(n_students_daily) as avg_absence_rate_etape,
            avg(cast(n_students_daily as float)) as weight_etape
        from {{ ref("abstsm_stg_daily_metrics") }} as src
        group by annee, school_friendly_name, etape_friendly, event_kind

    -- Estimate the per etape average absence_rate at the CSS level as the weighted
    -- average of the school's etape absence rate
    ),
    css as (
        select
            annee,
            etape_friendly,
            event_kind,
            sum(avg_absence_rate_etape * weight_etape)
            / sum(weight_etape) as avg_absence_rate_etape_css
        from source
        group by annee, etape_friendly, event_kind

    -- Compute the Average (past and future) absence rate for each school
    ),
    school as (
        select
            annee,
            school_friendly_name,
            event_kind,
            sum(absence_rate * n_students_daily)
            / sum(n_students_daily) as avg_absence_rate_school
        from {{ ref("abstsm_stg_daily_metrics") }} as src
        group by annee, school_friendly_name, event_kind

    -- add the css and school metrics to the table
    ),
    aggregated as (
        select
            src.annee,
            src.school_friendly_name,
            src.etape_friendly,
            src.weight_etape,
            src.event_kind,
            src.avg_absence_rate_etape,
            -- css
            css.avg_absence_rate_etape_css,
            -- school
            school.avg_absence_rate_school
        from source as src
        left join
            css
            on src.annee = css.annee
            and src.etape_friendly = css.etape_friendly
            and src.event_kind = css.event_kind
        left join
            school
            on src.annee = school.annee
            and src.school_friendly_name = school.school_friendly_name
            and src.event_kind = school.event_kind
    )

select
    -- Add a filter key to sync filters accross vues
    {{
        dbt_utils.generate_surrogate_key(
            ["annee", "school_friendly_name", "event_kind"]
        )
    }} as filter_key,
    etape_friendly,
    avg_absence_rate_etape,
    avg_absence_rate_etape_css,
    avg_absence_rate_school
from aggregated
