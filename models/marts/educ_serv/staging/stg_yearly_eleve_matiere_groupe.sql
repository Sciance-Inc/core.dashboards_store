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
    spi.fiche,
    spi.id_eco,
    spi.annee,
    mat_ele.mat,
    mat_ele.grp,
    mat_ele.etat,
    mat_ele.id_mat_ele,
    mat_ele.res_som,
    mat_ele.modele_etape,
    mat_ele.id_mat_grp,
    oa.date_deb,
    oa.date_fin,
    mg.leg_obj_term,
    mg.leg_obj_non_term
from {{ ref("spine") }} as spi
inner join
    {{ ref("i_gpm_e_mat_ele") }} as mat_ele
    on spi.fiche = mat_ele.fiche
    and spi.id_eco = mat_ele.id_eco
inner join {{ ref("i_gpm_t_mat_grp") }} as mg on mat_ele.id_mat_grp = mg.id_mat_grp
inner join
    {{ ref("i_gpm_t_org_annee") }} as oa
    on oa.annee = spi.annee
    and spi.annee >= {{ store.get_current_year() }} - 10
