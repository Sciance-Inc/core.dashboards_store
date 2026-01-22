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
<<<<<<< HEAD
-- Shadow the raw fact table 
with
    agg as (
        select
            lieu_jumele,
=======

-- Shadow the raw fact table 
with agg as (
        select 
            lieu_jumele, 
>>>>>>> e157f43 (feat(efficacite): ajout des tables de reporting)
            annee,
            categorie,
            corp_empl,
            stat_eng,
<<<<<<< HEAD
            sum(total_mnt_brut) as total_mnt_brut,
            sum(hrs_remunere) as hrs_remunere
        from {{ ref("eff_fact_paiement") }}
        group by lieu_jumele, annee, categorie, corp_empl, stat_eng
    )

select
    {{ dbt_utils.generate_surrogate_key(["agg.annee", "agg.lieu_jumele"]) }}
    as filter_key,
=======
            sum(total_mnt_brut) as total_mnt_brut, 
            sum(hrs_remunere) as hrs_remunere
        from {{ ref("eff_fact_paiement") }}
        group by 
            lieu_jumele, 
            annee,
            categorie,
            corp_empl,
            stat_eng
    )

select 
    {{
        dbt_utils.generate_surrogate_key(
            ["agg.annee", "agg.lieu_jumele"]
        )
    }} as filter_key,
>>>>>>> e157f43 (feat(efficacite): ajout des tables de reporting)
    map.categorie_lieu_jumele,
    agg.categorie,
    agg.corp_empl,
    agg.stat_eng,
    agg.total_mnt_brut,
    agg.hrs_remunere
from agg
<<<<<<< HEAD
left join
    {{ ref("dim_mapper_lieu_jumele") }} as map on agg.lieu_jumele = map.lieu_jumele
=======
left join {{ ref("dim_mapper_lieu_jumele")}} as map
    on agg.lieu_jumele = map.lieu_jumele
>>>>>>> e157f43 (feat(efficacite): ajout des tables de reporting)
