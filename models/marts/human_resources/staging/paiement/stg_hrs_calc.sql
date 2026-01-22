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
            CASE
                WHEN ce.corp_empl like '1%' THEN (ce.nb_hres_an / 260)
                WHEN ce.corp_empl like '2%' THEN ce.nb_hres_an / 260.9
                WHEN ce.corp_empl like '3%' AND se.stat_eng IN ('E1','E2','E3','E8') THEN 6.4 
                WHEN ce.corp_empl like '3%' AND se.stat_eng IN ('E4','E5','E6','E7') THEN CE.nb_hres_an / 200
                WHEN (ce.corp_empl like '4%' OR ce.corp_empl LIKE '5%') THEN (CONVERT(DECIMAL(7,2),LEFT(NB_HRE_SEM,2)) + CONVERT(DECIMAL(7,2),RIGHT(NB_HRE_SEM,2))/60) / 5
            END as nb_hres_jrs
        FROM {{ ref("i_pai_tab_corp_empl") }} ce
        CROSS JOIN {{ ref("i_pai_tab_stat_eng") }} se
    )

SELECT
    corp_empl,
    stat_eng,
    nb_hres_an,
    nb_hres_jrs
FROM src