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
with
    y_student as (select * from {{ ref("fact_yearly_student") }} as y_stud),

    mat_ele as (
        select
            y_student.*,
            mat_ele.id_mat_ele,
            mat_ele.mat,
            mat_ele.grp,
            mat_ele.etat,
            mat_ele.res_som,
            case
                when left(mat_ele.grp, 1) not like '[%0-9]%'  -- grp starting with a letter = retake
                then 1
                else 0
            end as reprise
        from y_student
        left join
            {{ ref("i_gpm_e_mat_ele") }} as mat_ele
            on y_student.fiche = mat_ele.fiche
            and y_student.id_eco = mat_ele.id_eco
        where
            mat_ele.res_som is not null  -- Prendre en note le risque de perdre des données pour la compétence. A voir à le 2e itérations.
            and mat_ele.etat != 0  -- -- 0 = inactive, 1 = active, 5 = en continuation, 6 = equivalence, 8 = terminee
            and (
                (
                    mat_ele.res_som like '%[0-9]%'
                    and (right(mat_ele.res_som, 1) like '%[0-9]%')
                    or (mat_ele.res_som in ('R', 'NR'))
                )
            )
    ),

    row_num as (
        select
            *,
            row_number() over (
                partition by fiche, id_eco, mat, reprise order by etat
            ) as seqid_res
        from mat_ele
    )

select
    code_perm,
    id_eco,
    annee,
    fiche,
    population,
    eco,
    code_ecole,
    ordre_ens,
    genre,
    plan_interv_ehdaa,
    niveau_scolaire,
    id_mat_ele,
    mat,
    grp,
    etat,
    case
        when res_som in ('NR') then '0' when res_som in ('R') then '100' else res_som
    end as res_num_mat,
    reprise
from row_num
where seqid_res = 1
