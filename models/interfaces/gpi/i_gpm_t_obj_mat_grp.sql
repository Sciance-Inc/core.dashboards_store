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
    planif,
    etape_eval_01,
    etape_eval_02,
    etape_eval_03,
    etape_eval_04,
    etape_eval_05,
    etape_eval_06,
    etape_eval_07,
    etape_eval_08,
    etape_eval_09,
    etape_eval_10,
    etape_eval_11,
    etape_eval_12,
    etape_eval_13,
    etape_eval_14,
    etape_eval_15,
    etape_eval_16,
    etape_eval_17,
    etape_eval_18,
    etape_eval_19,
    etape_eval_20,
    etape_eval_21,
    etape_eval_22,
    etape_eval_23,
    etape_eval_24,
    etape_eval_25,
    etape_eval_26,
    etape_eval_27,
    etape_eval_28,
    etape_eval_29,
    etape_eval_30,
    id_obj_mat,
    id_mat_grp
from {{ var("database_gpi") }}.dbo.gpm_t_obj_mat_grp
