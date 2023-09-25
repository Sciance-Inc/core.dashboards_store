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
{{ config(alias="fact_anc_2y") }}

with
    src as (
        select hempl.matr, hempl.date_eff, hempl.etat
        from {{ ref("i_paie_hemp") }} as hempl

        where hempl.type = 'A'
    ),

    -- Check if the user left the CSS
    bool as (
        select *, case when etat not like 'C%' then 0 else 1 end as hasleft from src
    ),

    -- Check the column hasleft if the employe is back during the current year
    lagged as (
        select
            *,
            lag(hasleft, 1, 0) over (
                partition by matr order by date_eff
            ) as hasleftlagged
        from bool
    ),

    -- Start a new periode once the employee is back in the cssxx
    start_ as (
        select
            *,
            case
                when hasleftlagged != hasleft and hasleftlagged = 1 then 1 else 0
            end as periodestart
        from lagged
    ),

    -- Distinct the number of period the employee has
    partition as (
        select
            *,
            sum(periodestart) over (
                partition by matr
                order by date_eff
                rows between unbounded preceding and current row
            ) as partitionid
        from start_
    ),

    -- Min date of each employee
    calc_date as (
        select *, min(date_eff) over (partition by matr) as min_date
        from partition
        group by matr, date_eff, etat, hasleft, hasleftlagged, periodestart, partitionid

    ),
    date_diff as (

        select
            matr,
            case
                when month(date_eff) < 7 then year(date_eff) - 1 else year(date_eff)
            end as annee_budgetaire,
            datediff(day, min_date, max(date_eff)) as delta_day,  -- Total of day the employee has been active
            max(partitionid) as periode
        from calc_date
        group by date_eff, matr, min_date
    ),

    sequence_id as (

        select
            matr,
            annee_budgetaire,
            delta_day,
            periode,
            row_number() over (
                partition by matr, annee_budgetaire, periode
                order by annee_budgetaire asc
            ) as seqid
        from date_diff
    ),

    anciennete as (

        select
            *,
            case
                when delta_day >= 730 then 1 else 0  -- 2 yrs
            end as anc_2ans
        from sequence_id
        where
            seqid = 1
            and annee_budgetaire
            between {{ store.get_current_year() }}
            - 5 and {{ store.get_current_year() }}
    )
select *
from anciennete
