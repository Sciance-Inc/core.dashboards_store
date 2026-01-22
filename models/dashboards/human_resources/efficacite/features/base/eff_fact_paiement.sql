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
    src.annee,
    src.lieu_jumele,
    coalesce(cat.categorie, 'Non catégorisé') as categorie,
    src.corp_empl,
    src.stat_eng,
    sum(src.total_mnt_brut) as total_mnt_brut,
    sum(src.hrs_remunere) as hrs_remunere
from {{ ref("stg_paiement_history") }} as src
left join {{ ref("eff_dim_categorie") }} cat on src.corp_empl = cat.corp_empl
where
    src.annee
    between {{ core_dashboards_store.get_current_year() - 4 }}
    and {{ core_dashboards_store.get_current_year() - 1 }}  -- 4 ans d'historique -> 2021 - 2024, 2022 - 2025...
group by src.annee, src.lieu_jumele, cat.categorie, src.corp_empl, src.stat_eng
