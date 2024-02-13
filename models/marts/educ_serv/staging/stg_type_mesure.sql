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
    franci as (
        select fiche, id_eco, string_agg(type_mesure, ', ') as type_mesure
        from {{ ref("i_gpm_e_mesures") }}
        group by fiche, id_eco

    )

select
    fiche,
    id_eco,
    case
        when
            type_mesure like '%11%'
            or type_mesure like '%22%'
            or type_mesure like '%23%'
            or type_mesure like '%32%'
            or type_mesure like '%33%'
            or type_mesure like '%34%'
        then 1
        else null
    end as francisation,
    type_mesure
from franci
