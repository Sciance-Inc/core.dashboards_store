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
{% set years_of_data_grades = var("marts")["educ_serv"]["recency"][
    "years_of_data_grades"
] %}

select
    src.id_obj_mat,
    src.id_eco,
    src.mat,
    case
        when src.obj_02 is null
        then src.obj_01
        else try_cast(concat(src.obj_01, '.', src.obj_02) as float)
    end as obj_01,
    src.obj_02,
    src.obj_03,
    src.obj_04,
    src.descr,
    src.descr_abreg,
    src.descr_det,
    src.pond_obj
from {{ var("database_gpi") }}.dbo.gpm_t_obj_mat as src
inner join
    {{ ref("i_gpm_t_eco") }} as eco
    on eco.id_eco = src.id_eco
    and eco.annee
    >= {{ core_dashboards_store.get_current_year() }} - {{ years_of_data_grades }}
