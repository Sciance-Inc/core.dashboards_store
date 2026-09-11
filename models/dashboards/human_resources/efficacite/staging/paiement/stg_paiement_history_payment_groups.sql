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
                "{{ this }}", ["matricule", "ref_empl", "date_fin_paiement"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["matricule", "no_cheq"]
            ),
        ],
    )
}}

with source as (select matr as matricule, no_cheq from {{ ref("i_pai_hchq") }})

select
    s.matricule,
    s.no_cheq,
    p.code_pmnt,
    p.mode_paiement,
    p.code_provenance,
    p.ref_empl,
    p.corp_empl,
    mp.lieu_jumele,
    sum(p.nb_unit) as nb_unit,
    sum(p.mnt) as total_mnt_brut,
    min(p.date_deb) as date_debut_paiement,
    max(p.date_fin) as date_fin_paiement,
    min(p.date_cheq) as date_cheq_paiement
from source s
left join
    {{ ref("i_pai_hchq_pmnt") }} p on s.matricule = p.matr and s.no_cheq = p.no_cheq
left join
    {{ ref("eff_lieu_trav_to_lieu_jumele") }} mp  -- Lien avec les lieux jumeles
    on p.lieu_trav = mp.lieu_trav
where code_pmnt is not null  -- Enleve les deductions non present dans grp_paiement
group by
    s.matricule,
    s.no_cheq,
    p.code_pmnt,
    p.mode_paiement,
    p.code_provenance,
    p.ref_empl,
    p.corp_empl,
    mp.lieu_jumele
