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
-- Liste les écoles GPI sans lieu de travail Paie correspondant.
-- Ces lignes ne doivent pas être ajoutées à eff_mapping_fgj_paie avant résolution.
with
    gpi as (
        select
            eco as ecole_gpi,
            max(nom_eco) as nom_ecole_gpi,
            max(cat_eco) as categorie_ecole_gpi
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

select gpi.ecole_gpi, gpi.nom_ecole_gpi, gpi.categorie_ecole_gpi
from gpi
left join paie on paie.lieu_trav = gpi.ecole_gpi
where paie.lieu_trav is null
