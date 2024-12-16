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
    Prendre les écoles qui sont définies dans les populations commes les écoles régulieres
#}
{% raw %}
with eleves_actives as (
        select id_eco,fiche
        from {{ ref("i_gpm_e_dan") }} as dan
        where statut_don_an = 'A'
    )

select elv_act.id_eco, fiche
from eleves_actives as elv_act
inner join {{ ref('i_gpm_t_eco') }} as eco on elv_act.id_eco = eco.id_eco
/*
where eco < '099'     -- Prendre les écoles qui sont définies dans les populations commes les écoles régulieres
    and annee > 2009  -- De quelle année le rapport prend les données
    and eco != '072'  -- enlever l'école d'été
    and fiche not in ('12345','54321') --Enlever les élèves qui figurent comme des doublons mais qui ne sont pas des doublons
*/
{% endraw %}