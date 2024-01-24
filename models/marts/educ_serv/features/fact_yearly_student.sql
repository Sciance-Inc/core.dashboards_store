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
    ele.nom,
    ele.pnom,
    concat(ele.nom, ', ', ele.pnom, ' (', ele.fiche, ' )') as nom_prenom_fiche,
    spi.annee,
    spi.fiche,
    spi.population,
    spi.eco,
    dan.grp_rep,
    dan.dist,
    mapper_school.school_friendly_name as nom_ecole,
    dan.ordre_ens,
    dan.classe,
    dan.class,
    case
        when ele.sexe = 'F' then 'Fille' when ele.sexe = 'M' then 'Garçon' else ele.sexe
    end as genre,
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
    end as niveau_scolaire,
    dan.difficulte,
    case
        when
            dan.ordre_ens = '3'
            and cycle_ref = 1
            and dan.annee_cycle_ref = 1
            and classe = 'A'
        then 0
        when
            dan.ordre_ens = '3'
            and cycle_ref = 1
            and dan.annee_cycle_ref = 7
            and classe = 'A'
        then 1
        when
            dan.ordre_ens = '3'
            and cycle_ref = 1
            and dan.annee_cycle_ref = 2
            and classe = 'B'
        then 0
        when
            dan.ordre_ens = '3'
            and cycle_ref = 1
            and dan.annee_cycle_ref = 8
            and classe = 'C'
        then 1
        when
            dan.ordre_ens = '3'
            and cycle_ref = 2
            and dan.annee_cycle_ref = 1
            and classe = 'D'
        then 0
        when
            dan.ordre_ens = '3'
            and cycle_ref = 2
            and dan.annee_cycle_ref = 7
            and classe = 'D'
        then 1
        when
            dan.ordre_ens = '3'
            and cycle_ref = 2
            and dan.annee_cycle_ref = 2
            and classe = 'E'
        then 0
        when
            dan.ordre_ens = '3'
            and cycle_ref = 2
            and dan.annee_cycle_ref = 8
            and classe = 'F'
        then 1
        when
            dan.ordre_ens = '3'
            and cycle_ref = 3
            and dan.annee_cycle_ref = 1
            and classe = 'G'
        then 0
        when
            dan.ordre_ens = '3'
            and cycle_ref = 3
            and dan.annee_cycle_ref = 7
            and classe = 'G'
        then 1
        when
            dan.ordre_ens = '3'
            and cycle_ref = 3
            and dan.annee_cycle_ref = 2
            and classe = 'H'
        then 0
        when
            dan.ordre_ens = '3'
            and cycle_ref = 3
            and dan.annee_cycle_ref = 8
            and classe = 'I'
        then 1
        when
            dan.ordre_ens = '4'
            and dan.dist like 'G%'
            and lag(substring(dan.dist, 1, 2)) over (
                partition by spi.fiche order by spi.annee
            )
            = substring(dan.dist, 1, 2)
        then 1
        when
            dan.ordre_ens = '2'
            and lag(dan.ordre_ens) over (partition by spi.fiche order by spi.annee)
            = dan.ordre_ens
        then 1
        else 0
    end as is_doubleur,
    dan.age_30_sept,
    mes.type_mesure,
    des_mes.cf_descr_abreg,
    zele.particularite_sante,
    zele.recommandations,
    zele.mesure_30810,
    zele.besoin_ressources

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
left join
    {{ ref("stg_type_mesure") }} as mes
    on spi.fiche = mes.fiche
    and spi.id_eco = mes.id_eco
left join
    {{ ref("i_wl_descr") }} as des_mes
    on des_mes.code = mes.type_mesure
    and nom_table = 'type_mesure'
left join {{ ref("i_gpm_e_ele_z_pers") }} as zele on spi.fiche = zele.fiche
where seqid = 1 and spi.annee >= {{ store.get_current_year() }} - 10  -- On garde un max de 10 ans dans nos données d'étudiants / Limite par défaut
