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
    Compute the full set of slicers for the two reports tables.

    Because of the double-granularity difference (age and school_year) between the rtmrt_report_retirement_age table and the trmrt_report_active_employees_age table, I can't properly combine the two report tables.
    Since powerbi doesn't support many-to-many relations, the filters have to be implemented in a separated table.
    
    That's gross.
#}
{{ config(alias="report_filters") }}


with
    one_for_all as (
        select
            src.gr_paie,
            src.date_jour,
            src.filter_key,
            max(src.filter_source) as filter_source
        from
            (
                select gr_paie, date_jour, filter_key, 'calendrier' as filter_source
                from {{ ref("dim_calendrier") }}
                union all
                select
                    gr_paie, date as date_jour, filter_key, 'absence' as filter_source
                from {{ ref("emp_abs_report_absence") }}
            ) as src
        group by src.gr_paie, src.date_jour, src.filter_key

    )

-- Join the friendly name
select src.gr_paie, src.date_jour, src.filter_key, src.filter_source
from one_for_all as src
inner join
    {{ ref("i_pai_tab_cal_jour") }} as cal
    on src.gr_paie = cal.gr_paie
    and src.date_jour = cal.date_jour

where
    type_jour != 'C'  -- Type_jour C => Congé | On ne le prend pas en compte
    and type_jour != 'E'  -- Type_jour E => Été | On ne le prend pas en compte
    and jour_sem != 0  -- jour_sem 0 => Dimanche | On ne le prend pas en compte
    and jour_sem != 6  -- jour_sem 6 => Samedi | On ne le prend pas en compte    
