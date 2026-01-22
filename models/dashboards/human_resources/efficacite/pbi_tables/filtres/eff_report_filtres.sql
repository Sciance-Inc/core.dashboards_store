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

with keys as (
    -- Select all possible filters values
    select
        {{
            dbt_utils.generate_surrogate_key(
                ["annee", "lieu_jumele"]
            )
        }} as filter_key,
        lieu_jumele,
        annee
    from {{ ref("eff_fact_paiement") }}
    group by lieu_jumele, annee
    union 
    select
        {{
            dbt_utils.generate_surrogate_key(
                ["annee", "lieu_jumele"]
            )
        }} as filter_key,
        lieu_jumele,
        annee
    from {{ ref("eff_fact_perf_ecole") }}
)

-- Add friendly names and metadatas 
select 
    k.filter_key,
    k.annee,
    CONCAT(k.annee, ' - ', k.annee + 1) as annee_scolaire,
    dm.nom_lieu_jumele,
    coalesce(dm.categorie_lieu_jumele, 'Lieu jumele non configuré') as categorie_lieu_jumele,
    dm.is_school_comparable,
    case when dm.nom_lieu_jumele is null then 1 else 0 end as _anomalie
from keys as k
left join {{ ref('dim_mapper_lieu_jumele') }} as dm
on dm.lieu_jumele = k.lieu_jumele 
where annee < {{ core_dashboards_store.get_current_year() }} -- Exclude the current year
