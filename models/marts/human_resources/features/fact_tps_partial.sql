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
{{ config(alias="fact_tps_partial") }}

select
    year(date_entr) as 'annee',
    lieu_trav as 'ecole',
    count(distinct matr) as 'total_employes'
from {{ ref("i_pai_dos_empl") }}
where
    (stat_eng = 'E3')  -- Statut d'emploi | E3 => Temps partiel
    and (year(getdate()) - year(date_entr) <= 10)  -- 10 dernières années    
group by date_entr, lieu_trav
