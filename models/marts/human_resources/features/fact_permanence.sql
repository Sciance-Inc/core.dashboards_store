{{ config(alias="fact_permanence") }}
-- Get all information needed
with
    stepone as (
        select
            emp.matr,
            emp.date_entr,
            seedetat.etat_actif,
            case
                when  -- Active employment
                    ind_empl_princ = 1  -- principal job
                then cast(getdate() as date)  -- Current date
                else emp.date_eff  -- End of employment day
            end as date_fin,
            emp.etat,
            emp.stat_eng,
            ind_empl_princ,
            corp_empl
        from {{ ref("i_pai_dos_empl") }} emp
        left join {{ ref("etat_empl") }} seedetat on emp.etat = seedetat.etat_empl
        left join
            {{ ref("stat_eng") }} seedstatuseng on emp.stat_eng = seedstatuseng.stat_eng
        where
            seedstatuseng.is_reg = 1  -- Only employees who are regular
            and seedetat.etat_actif = 1  -- Only employees who are actives
    ),

    -- Get the current job
    mainjob as (
        select stepone.matr, stepone.corp_empl from stepone where ind_empl_princ = 1
    ),

    -- Get all experiences wich has the same job group
    experience as (
        select
            exp.matr,
            exp.corp_empl,
            case
                when  -- Active employment
                    exp.etat_actif = 1 and exp.stat_eng like '%1' and ind_empl_princ = 1
                then datediff(dd, exp.date_entr, cast(getdate() as date)) / 365.0  -- Datediff with the current date
                else datediff(dd, exp.date_entr, exp.date_fin) / 365.0  -- Datediff with the end of employment day
            end as rangedate
        from stepone exp
        left join mainjob on exp.matr = mainjob.matr
        where left(exp.corp_empl, 1) = left(mainjob.corp_empl, 1)
    ),

    -- Sums of all experiences
    sumexp as (
        select experience.matr, mainjob.corp_empl, sum(rangedate) as nbryears
        from experience
        left join mainjob on experience.matr = mainjob.matr
        group by experience.matr, mainjob.corp_empl
    )

-- Display only the value required
select
    matr as matricule,
    corp_empl as corps_emploi,
    case when nbryears > 2 then 1 else 0 end as permanence  -- if nbrYears is greater than 2 then the employee as is permanence
from sumexp
group by matr, corp_empl, nbryears
