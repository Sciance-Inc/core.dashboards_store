with
    currentactive as (
        select matr, corp_empl, etat_empl, stat_eng, 1 as 'currently_active'
        from {{ ref("fact_activity_current") }}
    )

select
    util.matr,
    util.first_name + ' ' + util.last_name as full_name,
    util.email_address,
    emp.etat as state,
    emp.lieu_trav as workplace,
    util.sex,
    emp.corp_empl,
    emp.mode_cour,
    emp.type,
    emp.stat_eng,
    emp.etat,
    ca.currently_active
from {{ ref("dim_employees") }} as util
left join {{ ref("i_pai_dos_empl") }} emp on util.matr = emp.matr
left join currentactive ca on util.matr = ca.matr
where emp.etat like 'a%' and emp.ind_empl_princ = 1
