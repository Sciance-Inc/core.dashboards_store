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
select
    code as ordre_ens,
    cf_descr as desc_ordre_ens,
    case
        when code in (1, 2)
        then 'Préscolaire'  -- intégrer préscolaire 4 ans et préscolaire 5 ans à Préscolaire 
        when code in (3, 4)
        then cf_descr
    end desc_combiner_ordre_ens
from {{ ref("i_wl_descr") }}
where nom_table = 'ORDRE_ENS'
