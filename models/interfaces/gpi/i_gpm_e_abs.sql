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
{% set years_of_data_absences = var("marts")["educ_serv"]["recency"][
    "years_of_data_absences"
] %}

select src.date_abs, src.fiche, src.id_eco, src.motif_abs
from {{ var("database_gpi") }}.dbo.gpm_e_abs as src
with (nolock)
-- Filter on the last n years of data through a join on the school year table, to get
-- 'school year like' year.
inner join {{ ref("i_gpm_t_eco") }} as eco
with (nolock) on eco.id_eco = src.id_eco
where
    eco.annee
    >= {{ core_dashboards_store.get_current_year() }} - {{ years_of_data_absences }}
