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
select stud.fiche, grp_rep, cours_groupe
from {{ ref("fact_yearly_student") }} stud
left join
    {{ ref("i_coursgroupeseleves") }} as el
    on stud.eco = el.eco
    and stud.annee = el.annee
    and stud.fiche = el.fiche
where stud.annee = {{ core_dashboards_store.get_current_year() }}
