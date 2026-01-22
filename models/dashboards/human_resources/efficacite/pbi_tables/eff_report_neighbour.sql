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

-- TODO : REPLACE NEIGHBOUR_LIEU_JUMELE WITH INSITUTION FRIENDLY NAME  BEFORE TGE UNION (TO REPLACE EFF_FACT_ECART_NEIGHBOOR)

with base as (
    select 
        {{
            dbt_utils.generate_surrogate_key(
                ["src.annee", "src.lieu_jumele"]
            )
        }} as filter_key,
        -- Source school
        jml.nom_lieu_jumele,
        src.taux_reussite,
        src.cohort_difficulty_score,
        src.nb_totaux_eleve,
        src.ratio_heure_ele,
        -- Comparable
        jml_neighbour.nom_lieu_jumele as neighbour_nom_lieu_jumele,
        src.neighbour_taux_reussite,
        src.neighbour_cohorte_difficulty_score,
        src.neighbour_nb_totaux_eleve,
        src.neighbour_ratio_heure_ele,
        -- To later match expenses per category
        {{ dbt_utils.generate_surrogate_key( ["src.annee", "src.neighbour_lieu_jumele"]) }} as category_join_key
    from {{ ref("eff_fact_ecart_neighbour") }} as src
    left join {{ ref('dim_mapper_lieu_jumele') }} as jml on src.lieu_jumele = jml.lieu_jumele
    left join {{ ref('dim_mapper_lieu_jumele') }} as jml_neighbour on src.neighbour_lieu_jumele = jml_neighbour.lieu_jumele
    )

select
    filter_key,
    max(taux_reussite) as taux_reussite,
    max(cohort_difficulty_score) as cohort_difficulty_score,
    max(nb_totaux_eleve) as nb_totaux_eleve,
    max(ratio_heure_ele) as ratio_heure_ele,
    'school' as source,
    concat('(Source) - ', max(nom_lieu_jumele)) as target_nom_lieu_jumele,
    max(filter_key) as category_join_key
from base
group by filter_key
union
select
    filter_key,
    neighbour_taux_reussite,
    neighbour_cohorte_difficulty_score,
    neighbour_nb_totaux_eleve,
    neighbour_ratio_heure_ele,
    'neighbour' as source,
    concat('(Comparable) - ', neighbour_nom_lieu_jumele) as target_nom_lieu_jumele,
    category_join_key as category_join_key
from base
