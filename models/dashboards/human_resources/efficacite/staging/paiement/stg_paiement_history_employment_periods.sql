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
{{
    config(
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["matricule", "ref_empl", "date_debut_historique"]
            ),
        ],
    )
}}

with
    stg_activity as (
        select
            ah.matr,
            ah.school_year,
            ah.ref_empl,
            ah.corp_empl,
            ah.etat_empl,
            ah.stat_eng,
            ah.lieu_trav,
            ah.date_eff,
            ah.date_fin,
            hc.nb_hres_an,
            hc.nb_hres_jrs
        from {{ ref("stg_activity_history") }} ah
        left join
            {{ ref("stg_hrs_calc") }} hc
            on ah.corp_empl = hc.corp_empl
            and ah.stat_eng = hc.stat_eng
    )

-- Une ligne par période d'activité de stg_activity_history (les lignes de paie
-- consécutives aux mêmes attributs y sont déjà fusionnées en une seule période),
-- avec son lieu jumelé et les heures de référence du corps d'emploi.
select
    stg.matr as matricule,
    stg.ref_empl,
    stg.corp_empl,
    stg.etat_empl,
    stg.stat_eng,
    coalesce(mp.lieu_jumele, 'Lieu jumelé non configuré') as lieu_jumele,
    stg.date_eff as date_debut_historique,
    stg.date_fin as date_fin_historique,
    stg.nb_hres_an,
    stg.nb_hres_jrs
from stg_activity stg
left join {{ ref("eff_lieu_trav_to_lieu_jumele") }} mp on stg.lieu_trav = mp.lieu_trav  -- lieu_trav unique dans le seed
where stg.lieu_trav is not null
