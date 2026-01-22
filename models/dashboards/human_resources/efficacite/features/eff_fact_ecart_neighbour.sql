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
with
    base as (
        select
            eco.lieu_jumele,
            jml.categorie_lieu_jumele,
            annee,
            cast(taux_reussite as float) as taux_reussite,
            cast(cohort_difficulty_score as float) as cds,
            cast(ratio_heure_ele as float) as rhe,
            cast(nb_totaux_eleve as float) as nb,
            -- Compute the Norm of each school / year to later compute the cosinus
            -- between each combination
            sqrt(
                power(cast(cohort_difficulty_score as float), 2)
                + power(cast(ratio_heure_ele as float), 2)
                + power(cast(nb_totaux_eleve as float), 2)
            ) as vnorm
        from {{ ref("eff_fact_perf_ecole") }} as eco
        left join {{ ref('dim_mapper_lieu_jumele') }} as jml 
        on eco.lieu_jumele = jml.lieu_jumele
    ),

    neighbours as (
        select
            a.lieu_jumele,
            a.annee,
            a.taux_reussite,
            a.cds as cohort_difficulty_score,
            a.rhe as ratio_heure_ele,
            a.nb as nb_totaux_eleve,
            nn.neighbour_cohorte_difficulty_score,
            nn.neighbour_ratio_heure_ele,
            nn.neighbour_nb_totaux_eleve,
            nn.neighbour_lieu_jumele,
            nn.neighbour_taux_reussite,
            nn.cos_sim
        from
            base as a
            outer apply(
                select top 3
                    b.lieu_jumele as neighbour_lieu_jumele,
                    b.taux_reussite as neighbour_taux_reussite,
                    b.cds as neighbour_cohorte_difficulty_score,
                    b.rhe as neighbour_ratio_heure_ele,
                    b.nb as neighbour_nb_totaux_eleve,
                    -- Compute the cosinus similarity between each candidate, and the
                    -- pool of OTHER schools for the exact same year
                    cast(
                        ((a.cds * b.cds + a.rhe * b.rhe + a.nb * b.nb))
                        / nullif(a.vnorm * b.vnorm, 0.0) as float
                    ) as cos_sim
                from base as b
                where
                    b.annee = a.annee
                    and b.lieu_jumele <> a.lieu_jumele
                    and b.categorie_lieu_jumele = a.categorie_lieu_jumele -- Only compare schools belonging to the same category
                    and (a.vnorm > 0 and b.vnorm > 0)
                order by
                    -- Select the rows with the lower distance
                    (
                        (a.cds * b.cds + a.rhe * b.rhe + a.nb * b.nb)
                        / nullif(a.vnorm * b.vnorm, 0.0)
                    ) desc
            ) as nn
    )

select
    lieu_jumele,
    annee,
    taux_reussite,
    cohort_difficulty_score,
    ratio_heure_ele,
    nb_totaux_eleve,
    neighbour_cohorte_difficulty_score,
    neighbour_ratio_heure_ele,
    neighbour_nb_totaux_eleve,
    neighbour_lieu_jumele,
    neighbour_taux_reussite,
    cos_sim
from neighbours
