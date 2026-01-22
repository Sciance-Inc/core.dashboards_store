<<<<<<< HEAD
<<<<<<< HEAD
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
-- To compute the spread between a school sucess rate and it's closer comparable
=======
-- To compute the spread between a school sucess rate and it's closer comparable

>>>>>>> e157f43 (feat(efficacite): ajout des tables de reporting)
=======
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
-- To compute the spread between a school sucess rate and it's closer comparable
>>>>>>> 36ad5c1 (chore: sqlfmt et licence-checker)
with
    src as (
        select
            lieu_jumele,
            annee,
            max(taux_reussite) as taux_reussite,  -- Dummy aggregation
            -- Compute the average success rate for the 3 closer schools
            avg(neighbour_taux_reussite) as taux_moyen_voisins,
            -- Compute the weighted average success rate (the closer the schools, the
            -- higher the weight)
            sum(neighbour_taux_reussite * cos_sim)
            / nullif(sum(cos_sim), 0.0) as taux_moyen_pondere_voisins
        from {{ ref("eff_fact_ecart_neighbour") }}
        group by lieu_jumele, annee
    )

select
<<<<<<< HEAD
<<<<<<< HEAD
    {{ dbt_utils.generate_surrogate_key(["annee", "lieu_jumele"]) }} as filter_key,
    taux_reussite,
    taux_moyen_voisins,
    taux_moyen_pondere_voisins,
    cast(
        (taux_reussite - taux_moyen_voisins) * 100 as decimal(4, 2)
    ) as ecart_vs_voisins,
=======
    {{
        dbt_utils.generate_surrogate_key(
            ["annee", "lieu_jumele"]
        )
    }} as filter_key,
    taux_reussite,
    taux_moyen_voisins,
    taux_moyen_pondere_voisins,
    cast((taux_reussite - taux_moyen_voisins) * 100 as decimal(4,2)) as ecart_vs_voisins,
>>>>>>> e157f43 (feat(efficacite): ajout des tables de reporting)
=======
    {{ dbt_utils.generate_surrogate_key(["annee", "lieu_jumele"]) }} as filter_key,
    taux_reussite,
    taux_moyen_voisins,
    taux_moyen_pondere_voisins,
    cast(
        (taux_reussite - taux_moyen_voisins) * 100 as decimal(4, 2)
    ) as ecart_vs_voisins,
>>>>>>> 36ad5c1 (chore: sqlfmt et licence-checker)
    taux_reussite - taux_moyen_pondere_voisins as ecart_vs_voisins_pondere
from src
