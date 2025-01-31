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
{#
    Les élèves qui sont mal placés dans les classes selon l''ordre enseignement
#}
{{ config(alias="report_classe_ordre_enseignement") }}

with
    -- Predre tous les élèves actifs à partir de l'année qui est définie dans adapter
    eleves_actifs as (
        select fiche, dan.id_eco, annee, classe, ordre_ens
        from {{ ref("i_gpm_e_dan") }} as dan
        inner join gpi.gpi.dbo.gpm_t_eco as eco on eco.id_eco = dan.id_eco
        where
            statut_don_an = 'A'
            and dan.id_eco
            in (select id_eco from {{ ref("i_gpm_e_dan") }} group by id_eco)
    ),

    -- Ajouter une colonne pour iniquer que élèves d'adapter sont bien
    popl_anomalies as (
        select id_eco, fiche, 0 as is_conflict from {{ ref("anml_stg_population") }}

    ),

    -- Mapper les élèves avec les écoles et la description de l'ordre d'enseignement
    eleves_actifs_avec_ecoles as (
        select
            elv_act.fiche,
            elv_act.id_eco,
            elv_act.annee,
            school_friendly_name,
            classe,
            elv_act.ordre_ens,
            desc_ordre_ens,
            is_conflict
        from popl_anomalies as popl
        right join
            eleves_actifs as elv_act
            on elv_act.fiche = popl.fiche
            and elv_act.id_eco = popl.id_eco
        inner join {{ ref("dim_mapper_schools") }} as eco on elv_act.id_eco = eco.id_eco
        inner join
            {{ ref("anml_dim_ordre_enseignement") }} as dim
            on dim.ordre_ens = elv_act.ordre_ens
    ),

    -- Diviser les élèves selon la présence du conflit.
    eleves_classe_conflit as (
        select
            fiche,
            id_eco,
            annee,
            school_friendly_name,
            classe,
            ordre_ens,
            coalesce(is_conflict, 1) as is_conflict
        from eleves_actifs_avec_ecoles
    )
-- Les élèves qui ont un conflit de la classe selon l'ordre d'enseignement
select fiche, id_eco, annee, school_friendly_name, classe, ordre_ens, is_conflict
from eleves_classe_conflit
where is_conflict = 1
