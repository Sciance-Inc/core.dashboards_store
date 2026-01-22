-- To compute the spread between a school sucess rate and it's closer comparable

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
    {{
        dbt_utils.generate_surrogate_key(
            ["annee", "lieu_jumele"]
        )
    }} as filter_key,
    taux_reussite,
    taux_moyen_voisins,
    taux_moyen_pondere_voisins,
    cast((taux_reussite - taux_moyen_voisins) * 100 as decimal(4,2)) as ecart_vs_voisins,
    taux_reussite - taux_moyen_pondere_voisins as ecart_vs_voisins_pondere
from src
