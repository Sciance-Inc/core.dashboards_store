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
{% set max_etapes = var("interfaces")["gpi"]["max_etapes"] + 1 %}

select
    fiche,
    id_mat_ele,
    id_obj_mat,
    {% for i in range(1, max_etapes) %}
        cast(res_obj_{{ "%02d" % i }} as nvarchar) as res_obj_{{ "%02d" % i }},
    {% endfor %}
    res_final_obj
from {{ var("database_gpi") }}.dbo.gpm_e_obj
with (nolock)
