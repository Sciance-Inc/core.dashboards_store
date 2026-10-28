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
    Compute employment related properties for each employee.
    This table is a consolidated version of the paie_hempl with only the properties we are interested by,
    Properties are fetched from the paie_hempl table.

    Consecutive rows with the same set of attributes are merged together

 #}
{{
    config(
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["matr", "school_year", "ref_empl"]
            ),
        ],
    )
}}


with
    -- Compare each employment with its previous state
    source as (
        select
            hmp.matr,
            hmp.ref_empl,
            hmp.corp_empl,
            hmp.etat,
            hmp.lieu_trav,
            hmp.stat_eng,
            hmp.date_eff,
            hmp.date_fin,
            lag(corp_empl) over (
                partition by matr, ref_empl order by date_eff
            ) as previous_corp_empl,
            lag(etat) over (
                partition by matr, ref_empl order by date_eff
            ) as previous_etat,
            lag(lieu_trav) over (
                partition by matr, ref_empl order by date_eff
            ) as previous_lieu_trav,
            lag(stat_eng) over (
                partition by matr, ref_empl order by date_eff
            ) as previous_stat_eng,
            lag(date_fin) over (
                partition by matr, ref_empl order by date_eff
            ) as previous_date_fin
        from {{ ref("i_pai_hemp") }} as hmp

    -- Add a flag for every rupture of continuity
    ),
    continuity as (
        select
            matr,
            ref_empl,
            corp_empl,
            etat,
            lieu_trav,
            stat_eng,
            date_eff,
            date_fin,
            case
                when
                    -- EXCEPT treats two NULL attributes as equal.
                    not exists (
                        select corp_empl, etat, lieu_trav, stat_eng
                        except
                        select
                            previous_corp_empl,
                            previous_etat,
                            previous_lieu_trav,
                            previous_stat_eng
                    )
                    and {{
                        core_dashboards_store.weekdays_between(
                            "previous_date_fin", "date_eff"
                        )
                    }} <= 1
                then 0
                else 1
            end as is_rupture
        from source

    -- Sum the rupture flag within each employment
    ),
    sumed as (
        select
            matr,
            ref_empl,
            corp_empl,
            etat,
            lieu_trav,
            stat_eng,
            date_eff,
            date_fin,
            sum(is_rupture) over (
                partition by matr, ref_empl
                order by date_eff
                rows between unbounded preceding and current row
            ) as continuity_group_id
        from continuity

    -- Merge consecutive rows within each continuity group
    ),
    consolidated as (
        select
            matr,
            ref_empl,
            max(corp_empl) as corp_empl,  -- dummy aggregation
            max(etat) as etat,  -- dummy aggregation
            max(lieu_trav) as lieu_trav,  -- dummy aggregation
            max(stat_eng) as stat_eng,  -- dummy aggregation
            min(date_eff) as date_eff,  -- The lower bound of the continuity group
            max(date_fin) as date_fin  -- The upper bound of the continuity group
        from sumed
        group by matr, ref_empl, continuity_group_id
    )

-- Add metadata
select
    matr,
    {{ core_dashboards_store.get_school_year("date_eff") }} as school_year,
    ref_empl,
    corp_empl,
    etat as etat_empl,
    stat_eng,
    lieu_trav,
    date_eff,
    cast(
        case when date_fin > now_.now_ then now_.now_ else date_fin end as date
    ) as date_fin
from consolidated
cross join (select getdate() as now_) as now_
