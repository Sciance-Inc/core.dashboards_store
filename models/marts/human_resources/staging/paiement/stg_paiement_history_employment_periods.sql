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

select
    stg.matr as matricule,
    stg.ref_empl,
    stg.corp_empl,
    stg.etat_empl,
    stg.stat_eng,
    coalesce(mp.lieu_jumele, 'Lieu jumelé non configuré') as lieu_jumele,
    min(date_eff) as date_debut_historique,
    max(date_fin) as date_fin_historique,
    max(stg.nb_hres_an) as nb_hres_an,
    max(stg.nb_hres_jrs) as nb_hres_jrs
from stg_activity stg
left join {{ ref("eff_mapping_fgj_paie") }} mp on stg.lieu_trav = mp.lieu_trav
where stg.lieu_trav is not null
group by
    stg.matr,
    stg.ref_empl,
    stg.corp_empl,
    stg.etat_empl,
    stg.stat_eng,
    mp.lieu_jumele,
    stg.lieu_trav
