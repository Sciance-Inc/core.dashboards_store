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
    spi as (select fiche, id_eco, annee from {{ ref("spine") }}),

    mat_ele as (
        select
            spi.fiche,
            spi.id_eco,
            spi.annee,
            mat_ele.id_mat_ele,
            mat_ele.mat,
            mat_ele.grp,
            mat_ele.etat,
            mat_ele.res_som,
            case
                when left(mat_ele.grp, 1) not like '[%0-9]%'  -- grp starting with a letter = retake
                then 1
                else 0
            end as reprise,
            mg.leg_som

        from spi
        left join
            {{ ref("i_gpm_e_mat_ele") }} as mat_ele
            on spi.fiche = mat_ele.fiche
            and spi.id_eco = mat_ele.id_eco
        left join
            {{ ref("i_gpm_t_mat_grp") }} as mg on mat_ele.id_mat_grp = mg.id_mat_grp
        where
            mat_ele.res_som is not null  -- Prendre en note le risque de perdre des données pour la compétence. A voir à le 2e itérations.
            and mat_ele.etat != 0  -- -- 0 = inactive, 1 = active, 5 = en continuation, 6 = equivalence, 8 = terminee

    ),

    row_num as (
        select
            *,
            row_number() over (
                partition by fiche, id_eco, mat, reprise order by etat
            ) as seqid_res
        from mat_ele
    ),
    res_num as (

        select
            row_num.id_eco,
            annee,
            fiche,
            id_mat_ele,
            mat,
            grp,
            etat,
            res_som,
            case
                when cote is not null
                then note_equiv
                when isnumeric(res_som) = 1
                then convert(int, res_som)
                else null
            end as res_num_som,
            case
                when cote is not null and indic_reus_echec = '1'
                then 'R'
                when cote is not null and indic_reus_echec = '2'
                then 'E'
                when (seuil_reus is null) or (isnumeric(res_som) <> 1)
                then 'N/A'
                when res_som >= seuil_reus
                then 'R'
                when res_som < seuil_reus
                then 'E'
                else 'N/A'
            end as ind_reussite,
            reprise
        from row_num
        left join
            {{ ref("i_gpm_t_leg") }} as leg
            on leg.id_eco = row_num.id_eco
            and leg.leg = row_num.leg_som
        left join
            {{ ref("i_gpm_t_cotes") }} as cote
            on cote.id_eco = leg.id_eco
            and cote.leg = leg.leg
            and cote.cote = row_num.res_som
        where seqid_res = 1
    )
select
    id_eco,
    annee,
    fiche,
    id_mat_ele,
    mat,
    grp,
    etat,
    res_som,
    case
        when annee = 2019 and res_som in ('NR')
        then 0
        when annee = 2019 and res_som in ('R')
        then 100
        else res_num_som
    end as res_num_som,
    reprise
from res_num
