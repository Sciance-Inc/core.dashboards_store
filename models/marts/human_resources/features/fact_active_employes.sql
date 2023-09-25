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
    List all current ACTIVES employes at the time of the ETL run and provide some metadata such as worplace and employment category.

    For an employes to be active it must have been paid in the last two weeks and have a status set as active (from the seed).
 #}
-- Fetch the activity codes from the seed
with
    actives_etat_empl as (
        select distinct etat_empl from {{ ref("etat_empl") }} where etat_actif = 1

    -- Fetch the basee list of active employes, thoose with at least one payement in
    -- the last two weeks
    ),
    active_employees as (
        select matr
        from {{ ref("i_pai_dos") }} as src
        where etat_doss = 'A' and date_dern_paie > dateadd(week, -2, getdate())  -- Make sure the activte employes have been paid in the last two weeks

    -- Fetch their last known workplace, engagement status and workgroup
    ),
    active_employees_metadata as (
        select
            src.matr,
            empl.etat,
            empl.lieu_trav,
            empl.corp_empl,
            empl.stat_eng,
            row_number() over (
                partition by src.matr order by empl.ref_empl desc
            ) as seq_id
        from active_employees as src
        -- Add the 
        left join {{ ref("i_pai_dos_empl") }} as empl on src.matr = empl.matr
        inner join
            actives_etat_empl as act  -- Remove the employees with a Non-Active status
            on empl.etat = act.etat_empl
    )

select matr, etat, lieu_trav, corp_empl, stat_eng
from active_employees_metadata
where seq_id = 1  -- Only keep the last known set of metadatas
