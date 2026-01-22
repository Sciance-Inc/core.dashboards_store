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
with
    src as (
        select
            ce.corp_empl,
            se.stat_eng,
            ce.nb_hres_an,
            -- met sur un dénominateur commun les hrs calculés en jrs
            case
                when ce.corp_empl like '1%'
                then (ce.nb_hres_an / 260)
                when ce.corp_empl like '2%'
                then ce.nb_hres_an / 260.9
                when ce.corp_empl like '3%' and se.stat_eng in ('E1', 'E2', 'E3', 'E8')
                then 6.4
                when ce.corp_empl like '3%' and se.stat_eng in ('E4', 'E5', 'E6', 'E7')
                then ce.nb_hres_an / 200
                when (ce.corp_empl like '4%' or ce.corp_empl like '5%')
                then
                    (
                        convert(decimal(7, 2), left(nb_hre_sem, 2))
                        + convert(decimal(7, 2), right(nb_hre_sem, 2)) / 60
                    )
                    / 5
            end as nb_hres_jrs
        from {{ ref("i_pai_tab_corp_empl") }} ce
        cross join {{ ref("i_pai_tab_stat_eng") }} se
    )

select corp_empl, stat_eng, nb_hres_an, nb_hres_jrs
from src
