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
SELECT 
    fiche
    , id_mat_ele
    , id_obj_mat
    , res_final_obj
    , res_obj_01
    , res_obj_02
    , res_obj_03
    , res_obj_04
    , res_obj_05
    , res_obj_06
    , res_obj_07
    , res_obj_08
    , res_obj_09
    , res_obj_10
FROM {{ var("database_gpi") }}.dbo.gpm_e_obj