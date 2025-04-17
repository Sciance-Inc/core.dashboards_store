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
{# lier les intervenant (tuteurs) à leurs grp_rep afin de controler l'affichage des données des TdB #}
with
    intv as (
        select eco.eco as code_ecole, grp.grp_rep, intv.adr_electr
        from {{ ref("i_gpm_t_grp_rep") }} as grp
        left join
            {{ ref("i_gpm_t_interv") }} as intv
            on intv.id_eco = grp.id_eco
            and (intv.interv = grp.interv_1 or intv.interv = grp.interv_2)
        left join {{ ref("i_gpm_t_eco") }} as eco on grp.id_eco = eco.id_eco
        where
            intv.adr_electr is not null
            and eco.annee = {{ core_dashboards_store.get_current_year() }}
    )
select code_ecole, grp_rep, adr_electr
from intv
