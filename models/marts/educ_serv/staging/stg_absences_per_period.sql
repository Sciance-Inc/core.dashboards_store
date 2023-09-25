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
	This (sparse) table compute the number of absence periods per day and per students, for every student with at least one absence on a given day.
#}
select
    case
        when month(date_abs) <= 7 then year(date_abs) - 1 else year(date_abs)
    end as school_year,
    date_abs,
    fiche,
    id_eco,
    count(*) as n_periods_of_absence
from {{ ref("i_gpm_e_abs") }}
group by date_abs, fiche, id_eco
