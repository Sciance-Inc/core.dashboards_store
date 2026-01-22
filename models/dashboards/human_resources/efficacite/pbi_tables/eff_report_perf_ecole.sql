select 
    {{
        dbt_utils.generate_surrogate_key(
            ["annee", "lieu_jumele"]
        )
    }} as filter_key,
    hrs_remunere,
    nb_totaux_eleve,
    taux_reussite,
    cohort_difficulty_score,
    ratio_heure_ele
from {{ ref('eff_fact_perf_ecole') }}