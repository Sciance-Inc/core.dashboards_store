{{
    config(
        alias="report_emp_conge",
    )
}}

with
    agg as (
        select
            annee,
            lieu_trav,
            lieu_trav_descr,
            corps_demploi_description,
            etat_description,
            cong_lt,
            count(matricule) as n_matr
        from {{ ref("empcong_fact_emp_conge") }}
        where
            annee
            between {{ store.get_current_year() }}
            - 10 and {{ store.get_current_year() }}
        group by
            annee,
            lieu_trav,
            lieu_trav_descr,
            corps_demploi_description,
            etat_description,
            cong_lt
    )

select
    annee,
    concat(lieu_trav, ' | ', lieu_trav_descr) as lieu_trav,
    corps_demploi_description,
    etat_description,
    n_matr,
    case when cong_lt = 1 then 'Oui' else 'Non' end as cong_lt
from agg
