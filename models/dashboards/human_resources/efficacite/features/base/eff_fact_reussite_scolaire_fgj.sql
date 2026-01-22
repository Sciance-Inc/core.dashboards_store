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
    source as (select fiche, lieu_jumele, annee from {{ ref("eff_fact_eleve_fgj") }}),

    res_primaire as ( 
        select 
            fiche, 
            annee,
            res_etape_num
        from {{ ref("fact_resultat_etape_competence") }} as cpt
        where 
            etape = 'EX'  -- Ministère.
            and code_matiere in ('FRA400', 'FRA600', 'MAT600')  -- Matière aux ministères au primaire.
            and no_comp != '3'  -- n'est pas dans l'évaluation au meq.
            and res_etape_num is not null  -- Exclus les résultats null
    ),

    resultat_union as (
        select
            ele.fiche,
            ele.lieu_jumele,
            ele.annee,
            case
                when res.res_final_num is not null and res.res_final_num >= 60
                then 1.
                else 0.
            end as is_reussite
        from source ele
        inner join {{ ref("rstep_fact_epreuves_uniques") }} res  -- res secondaire seulement
            on ele.fiche = res.fiche
            and ele.annee = res.annee
        where res.res_final_num is not null  -- Exclus les res non numérique.
        union  -- Union les résultats du primaire.
        select
            ele.fiche,
            ele.lieu_jumele,
            ele.annee,
            case
                when res.res_etape_num is not null and res.res_etape_num >= 60
                then 1.
                else 0.
            end as is_reussite
        from source ele
        inner join res_primaire as res
            on ele.fiche = res.fiche
            and ele.annee = res.annee

    ),

    agg_res as (
        select
            lieu_jumele,
            annee,
            cast(avg(is_reussite) as decimal(5, 4)) as taux_reussite,
            count(fiche) as nb_eleve
        from resultat_union 
        group by lieu_jumele, annee
    )

select lieu_jumele, annee, taux_reussite
from agg_res
