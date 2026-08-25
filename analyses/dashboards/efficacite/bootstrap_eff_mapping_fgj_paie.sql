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
-- Génère les lignes valides de la seed eff_mapping_fgj_paie.
-- Convention : le lieu jumelé est le code école GPI lorsque la liaison est exacte.
with
    gpi as (
        select eco as ecole_gpi
        from {{ ref("i_gpm_t_eco") }}
        where eco is not null and eco <> '000'
        group by eco
    ),

    paie as (
        select lieu_trav
        from {{ ref("i_pai_tab_lieu_trav") }}
        where lieu_trav is not null
        group by lieu_trav
    )

select paie.lieu_trav, gpi.ecole_gpi, gpi.ecole_gpi as lieu_jumele
from gpi
inner join paie on paie.lieu_trav = gpi.ecole_gpi
