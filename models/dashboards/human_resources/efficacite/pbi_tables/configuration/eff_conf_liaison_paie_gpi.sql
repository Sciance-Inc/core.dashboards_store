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
    lieux_jumeles as (
        select lieu_jumele
        from {{ ref("eff_lieu_trav_to_lieu_jumele") }}

        union

        select lieu_jumele
        from {{ ref("eff_ecole_gpi_to_lieu_jumele") }}
    ),

    paie as (
        select
            lieu_jumele,
            string_agg(cast(lieu_trav as nvarchar(max)), ', ') as lieu_trav
        from {{ ref("eff_lieu_trav_to_lieu_jumele") }}
        group by lieu_jumele
    ),

    gpi as (
        select
            lieu_jumele,
            string_agg(cast(ecole_gpi as nvarchar(max)), ', ') as ecole_gpi
        from {{ ref("eff_ecole_gpi_to_lieu_jumele") }}
        group by lieu_jumele
    )

select paie.lieu_trav, gpi.ecole_gpi, lieux_jumeles.lieu_jumele
from lieux_jumeles
left join paie on lieux_jumeles.lieu_jumele = paie.lieu_jumele
left join gpi on lieux_jumeles.lieu_jumele = gpi.lieu_jumele
