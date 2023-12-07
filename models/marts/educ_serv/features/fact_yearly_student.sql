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
    spi.code_perm,
    spi.id_eco,
    spi.annee,
    spi.fiche,
    spi.population,
    spi.eco,
    dan.grp_rep,
    dan.dist,
    mapper_school.school_friendly_name as nom_ecole,
    dan.ordre_ens,
    case when ele.sexe = 'F' then 'Fille' when ele.sexe = 'M' then 'Garçon' end as genre
    ,
    case
        when dan.plan_interv_ehdaa is null
        then 'Sans'
        when dan.plan_interv_ehdaa = '1'
        then 'Avec'
        else dan.plan_interv_ehdaa
    end as plan_interv_ehdaa,
    case
        when
            dan.ordre_ens = '3'
            and (
                dan.cycle_ref = '1'
                and (dan.annee_cycle_ref = '1' or dan.annee_cycle_ref = '7')
            )
        then 'Prim 1'
        when
            dan.ordre_ens = '3'
            and (
                dan.cycle_ref = '1'
                and (dan.annee_cycle_ref = '2' or dan.annee_cycle_ref = '8')
            )
        then 'Prim 2'
        when
            dan.ordre_ens = '3'
            and (
                dan.cycle_ref = '2'
                and (dan.annee_cycle_ref = '1' or dan.annee_cycle_ref = '7')
            )
        then 'Prim 3'
        when
            dan.ordre_ens = '3'
            and (
                dan.cycle_ref = '2'
                and (dan.annee_cycle_ref = '2' or dan.annee_cycle_ref = '8')
            )
        then 'Prim 4'
        when
            dan.ordre_ens = '3'
            and (
                dan.cycle_ref = '3'
                and (dan.annee_cycle_ref = '1' or dan.annee_cycle_ref = '7')
            )
        then 'Prim 5'
        when
            dan.ordre_ens = '3'
            and (
                dan.cycle_ref = '3'
                and (dan.annee_cycle_ref = '2' or dan.annee_cycle_ref = '8')
            )
        then 'Prim 6'
        when dan.ordre_ens = '1'
        then 'Mat 4'
        when dan.ordre_ens = '2'
        then 'Mat 5'
        when
            dan.ordre_ens = '4'
            and (
                dan.cycle_ref = '1'
                and (dan.annee_cycle_ref = '1' or dan.annee_cycle_ref = '7')
            )
        then 'Sec 1'
        when
            dan.ordre_ens = '4'
            and (
                dan.cycle_ref = '1'
                and (dan.annee_cycle_ref = '2' or dan.annee_cycle_ref = '8')
            )
        then 'Sec 2'
        when
            dan.ordre_ens = '4'
            and (
                (
                    dan.cycle_ref = '2'
                    and (dan.annee_cycle_ref = '1' or dan.annee_cycle_ref = '7')
                )
                or dan.classe = '3'
            )
        then 'Sec 3'
        when
            dan.ordre_ens = '4'
            and (
                (
                    dan.cycle_ref = '2'
                    and (dan.annee_cycle_ref = '2' or dan.annee_cycle_ref = '8')
                )
                or dan.classe = '4'
            )
        then 'Sec 4'
        when
            dan.ordre_ens = '4'
            and (
                (
                    dan.cycle_ref = '2'
                    and (dan.annee_cycle_ref = '3' or dan.annee_cycle_ref = '9')
                )
                or dan.classe in ('5', '7', '8')
            )
        then 'Sec 5'
        else '-'
    end as niveau_scolaire
-- spi.seqid
from {{ ref("spine") }} as spi
inner join
    {{ ref("i_gpm_e_dan") }} as dan  -- Niv scolaire
    on spi.fiche = dan.fiche
    and spi.id_eco = dan.id_eco
inner join
    {{ ref("i_gpm_e_ele") }} as ele  -- Genre, PI
    on spi.fiche = ele.fiche
inner join
    {{ ref("dim_mapper_schools") }} as mapper_school
    on spi.id_eco = mapper_school.id_eco
where seqid = 1 and spi.annee >= {{ store.get_current_year() }} - 10  -- On garde un max de 10 ans dans nos données d'étudiants / Limite par défaut
