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
    paiement as (
        select 
            lieu_jumele, 
            annee, 
            sum(total_mnt_brut) as total_mnt_brut, 
            sum(hrs_remunere) as hrs_remunere
        from {{ ref("eff_fact_paiement") }}
        group by 
            lieu_jumele, 
            annee
    ),

    -- number of pupils
    n_pupils as (
        select 
            lieu_jumele, 
            annee,
            count(*) as n_pupils
        from {{ ref('eff_fact_eleve_fgj') }} 
        group by lieu_jumele, annee
    ),

    res_ele as (
        select lieu_jumele, annee, taux_reussite
        from {{ ref('eff_fact_reussite_scolaire_fgj') }} 
    ),

    score_diff as (
        select lieu_jumele, annee, cohort_difficulty_score
        from {{ ref('eff_fact_coef_difficulte') }} 
    ),

    spine as ( 
        select distinct lieu_jumele, annee
        from paiement
        union 
        select distinct lieu_jumele, annee
        from n_pupils
        union
        select distinct lieu_jumele, annee
        from res_ele
        union
        select distinct lieu_jumele, annee
        from score_diff
    ), 

    metrics_raw as ( 
        select 
            spi.lieu_jumele,
            spi.annee,
            -- paiement
            p.total_mnt_brut, 
            p.hrs_remunere,
            -- n student
            n.n_pupils,
            -- res 
            r.taux_reussite,
            -- score 
            s.cohort_difficulty_score
        from spine as spi
        left join paiement as p on spi.lieu_jumele = p.lieu_jumele and spi.annee = p.annee
        left join n_pupils as n on spi.lieu_jumele = n.lieu_jumele and spi.annee = n.annee
        left join res_ele as r on spi.lieu_jumele = r.lieu_jumele and spi.annee = r.annee
        left join score_diff as s on spi.lieu_jumele = s.lieu_jumele and spi.annee = s.annee
        join {{ ref('eff_reporting_configuration') }} as config on spi.lieu_jumele = config.lieu_jumele and config.is_school_comparable = 1
        where spi.annee between {{ core_dashboards_store.get_current_year() - 4 }} and {{ core_dashboards_store.get_current_year() - 1 }} 
    )

select 
    lieu_jumele,
    annee,
    -- Raw metrics
    hrs_remunere,
    n_pupils as nb_totaux_eleve,
    taux_reussite,
    cohort_difficulty_score,
    -- augmented 
    round(hrs_remunere * 1.0 / nullif(n_pupils, 0), 2) as ratio_heure_ele
from metrics_raw        