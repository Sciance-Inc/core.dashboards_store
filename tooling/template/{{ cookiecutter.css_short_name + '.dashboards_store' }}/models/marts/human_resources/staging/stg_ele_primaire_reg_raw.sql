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
    UPDATE THIS FILE TO MATCH YOUR CSS REALITY.
    This raw population is used by human_resources models and should include
    inactive students. Do not copy the educ_serv active-student filter blindly.
#}
{% raw %}
select distinct
    ele.code_perm,
    eco.id_eco,
    eco.annee
from {{ ref("i_gpm_e_dan") }} as eledan
left join {{ ref("i_gpm_t_eco") }} as eco on eledan.id_eco = eco.id_eco
left join {{ ref("i_gpm_e_ele") }} as ele on eledan.fiche = ele.fiche
where
    eledan.ordre_ens = '3'
    /*
    Add CSS-specific rules for the regular primary population.
    Do not filter on eledan.statut_don_an; this raw adapter includes inactive students.
    */
{% endraw %}
