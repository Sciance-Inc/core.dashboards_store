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
    id_mat_grp,
    id_eco,
    mat,
    grp,
    leg_obj_term,
    leg_obj_non_term,
    eval_res_obj_final,
    leg_som,
    leg_obj_final,
    leg_etape_01,
    leg_etape_02,
    leg_etape_03,
    leg_etape_04,
    leg_etape_05,
    leg_etape_06,
    leg_etape_07,
    leg_etape_08,
    leg_etape_09,
    leg_etape_10,
    leg_etape_11,
    leg_etape_12,
    leg_etape_13,
    leg_etape_14,
    leg_etape_15,
    leg_etape_16,
    leg_etape_17,
    leg_etape_18,
    leg_etape_19,
    leg_etape_20,
    leg_etape_21,
    leg_etape_22,
    leg_etape_23,
    leg_etape_24,
    leg_etape_25,
    leg_etape_26,
    leg_etape_27,
    leg_etape_28,
    leg_etape_29,
    leg_etape_30,
    eval_res_etape_01,
    eval_res_etape_02,
    eval_res_etape_03,
    eval_res_etape_04,
    eval_res_etape_05,
    eval_res_etape_06,
    eval_res_etape_07,
    eval_res_etape_08,
    eval_res_etape_09,
    eval_res_etape_10,
    eval_res_etape_11,
    eval_res_etape_12,
    eval_res_etape_13,
    eval_res_etape_14,
    eval_res_etape_15,
    eval_res_etape_16,
    eval_res_etape_17,
    eval_res_etape_18,
    eval_res_etape_19,
    eval_res_etape_20,
    eval_res_etape_21,
    eval_res_etape_22,
    eval_res_etape_23,
    eval_res_etape_24,
    eval_res_etape_25,
    eval_res_etape_26,
    eval_res_etape_27,
    eval_res_etape_28,
    eval_res_etape_29,
    eval_res_etape_30
from {{ var("database_gpi") }}.dbo.gpm_t_mat_grp
