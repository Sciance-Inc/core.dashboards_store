with 
    -- Compute the Y matrix
    y_long as ( 
        select 
            fgj.lieu_jumele,
            fgj.annee,
            cpt.code_matiere,
            count(cpt.res_etape_num) as n_attempts,
            sum(case when cpt.res_etape_num > 60 then 1 else 0 end) as n_success
        from {{ ref("eff_fact_eleve_fgj") }} as fgj
        join {{ ref("fact_resultat_etape_competence") }} as cpt
        on 
            fgj.fiche = cpt.fiche and
            fgj.annee = cpt.annee
        where 
            cpt.etape = 'EX'  -- Ministère.
            and cpt.code_matiere in ('FRA400', 'FRA600', 'MAT600')
            and cpt.no_comp != '3'
            and cpt.res_etape_num is not null 
        group by 
            fgj.lieu_jumele,
            fgj.annee,
            cpt.code_matiere
    
    -- Pivot the table
    ), y_wide as (
        select 
            lieu_jumele,
            annee,
            -- n_attempts
            max(case when code_matiere = 'FRA400' then n_attempts else null end) as n_attempts_fra_q,
            max(case when code_matiere = 'FRA600' then n_attempts else null end) as n_attempts_fra_s,
            max(case when code_matiere = 'MAT600' then n_attempts else null end) as n_attempts_mat_s,
            -- n_success
            max(case when code_matiere = 'FRA400' then n_success else null end) as n_success_fra_q,
            max(case when code_matiere = 'FRA600' then n_success else null end) as n_success_fra_s,
            max(case when code_matiere = 'MAT600' then n_success else null end) as n_success_mat_s
        from y_long
        group by 
            lieu_jumele,
            annee
    
    -- Compute the school_attributes
    ), school_attributes as (
        select 
            annee,
            lieu_jumele,
            count(*) as n_eleves,
            avg(is_difficulte * 1.0) as is_difficulte_proportion,
            avg(is_pi * 1.0) as is_pi_proportion
        from {{ ref("eff_fact_eleve_fgj") }} as fgj
        group by
            annee,
            lieu_jumele
    )

-- Combine into the partial design matrix
select 
    y.annee,
    y.lieu_jumele,
    -- Y
    y.n_attempts_fra_q,
    y.n_attempts_fra_s,
    y.n_attempts_mat_s,
    y.n_success_fra_q,
    y.n_success_fra_s,
    y.n_success_mat_s,
    -- X
    x.n_eleves,
    x.is_difficulte_proportion,
    x.is_pi_proportion
from y_wide as y
join school_attributes as x
on 
    y.annee = x.annee and 
    y.lieu_jumele = x.lieu_jumele
