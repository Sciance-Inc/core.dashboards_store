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
    annee,
    per,  -- - period AM and PM
    idparc,  -- key id  connect to i_geo_e_ele_trsp_parc
    simul,  -- - 0                                 
    noparc as no_parc,
    nom as nom_parc,
    indactive as ind_active,  -- active/inactive                                                       
    -- , IndAvisTransp AS ind_avis_transp
    nocirc as no_circ
from {{ var("database_geobus") }}.dbo.geo_p_parc
