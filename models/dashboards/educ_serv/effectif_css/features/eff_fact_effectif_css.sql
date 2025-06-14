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
{{ config(alias="fact_effectif_css") }}


with
    src as (
        select *
        from {{ ref("fact_yearly_student") }}
        where
            annee
            between {{ core_dashboards_store.get_current_year() }} -4
            and {{ core_dashboards_store.get_current_year() }}
            + 1
    ),

    el as (
        select
            src.code_perm,
            annee,
            src.population,
            ele.genre,
            eco,
            -- eco.nom_eco,
            classe,
            class,
            ordre_ens,
            plan_interv_ehdaa,
            difficulte,
            niveau_scolaire,
            coalesce(passp.code_perm, null) as is_passepartout,
            dist,
            is_doubleur,
            is_francisation,
            type_mesure,
            grp_rep
        from src
        left join {{ ref("dim_eleve") }} as ele on src.fiche = ele.fiche
        left join
            {{ ref("stg_check_passepartout") }} as passp
            on passp.code_perm = src.code_perm
            and passp.id_eco = src.id_eco
    ),
    elfiltre as (
        select
            code_perm,
            annee,
            population,
            genre,
            eco,
            -- eco.nom_eco,
            classe,
            class,
            ordre_ens,
            plan_interv_ehdaa,
            difficulte,
            case
                when is_passepartout is not null
                then 'Passe-Partout'
                else niveau_scolaire
            end as niveau_scolaire,
            dist,
            is_doubleur,
            is_francisation,
            type_mesure,
            grp_rep
        from el
    )
select *
from elfiltre
