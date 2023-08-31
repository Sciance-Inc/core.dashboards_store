{# 
    Extract the first retirement date for all of the employees.
#}
-- Extract all the valid retirement etat as well as the the corps_empl, lieu_trav and
-- stat_eng at the time of retirement
with
    retirements as (
        select
            matr,
            etat,
            corp_empl,
            lieu_trav,
            stat_eng,
            date_eff as retirement_date,
            row_number() over (
                partition by matr order by date_eff, ref_empl desc
            ) as seqid
        from {{ ref("i_pai_dos_empl") }} as empl
        inner join
            (select etat_empl from {{ ref("etat_empl") }} where empl_retr = 1) as dim
            on empl.etat = dim.etat_empl

    -- Remove any duplicates
    ),
    first_retirement as (
        select matr, etat, corp_empl, lieu_trav, stat_eng, retirement_date
        from retirements
        where seqid = 1

    -- Compute the retirement age and add some metadata
    ),
    retirement_age as (
        select
            frst.matr,
            frst.etat,
            frst.corp_empl,
            frst.lieu_trav,
            frst.stat_eng,
            frst.retirement_date,
            datediff(year, dos.date_nais, frst.retirement_date) as retirement_age
        from first_retirement as frst
        left join {{ ref("i_pai_dos") }} as dos on frst.matr = dos.matr
    )

select *
from retirement_age
