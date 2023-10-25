{#
dashboards store - helping students, one dashboard at a time.
copyright (c) 2023  sciance inc.

this program is free software: you can redistribute it and/or modify
it under the terms of the gnu affero general public license as
published by the free software foundation, either version 3 of the
license, or any later version.

this program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu affero general public license for more details.

you should have received a copy of the gnu affero general public license
along with this program.  if not, see <https://www.gnu.org/licenses/>.
#}
with
    row_num as (
        select
            obj_mat.id_obj_mat,
            obj_mat.mat,
            obj_mat.obj_01,
            obj_mat.obj_02,
            obj_mat.obj_03,
            obj_mat.obj_04,
            obj_mat.descr,
            obj_mat.descr_abreg,
            row_number() over (
                partition by obj_mat.mat, obj_mat.obj_01
                order by obj_mat.id_obj_mat desc
            ) as seqid
        from {{ ref("i_gpm_t_obj_mat") }} as obj_mat
        where descr is not null
    )

select *
from row_num
