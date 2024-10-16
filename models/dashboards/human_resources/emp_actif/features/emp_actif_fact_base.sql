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
{# 
    Compute a base table for all active employees with metadata attached to their main job.
#}
{{ config(alias="fact_emp_actif") }}

with
    -- Select all active employes
    actives as (
        select
            dim_e.matr,
            dim_e.legal_name,
            dim_e.sex_friendly_name,
            dim_e.email_address,
            emp.etat,
            emp.stat_eng,
            emp.corp_empl,
            emp.lieu_trav,
            -- Remuneration
            emp.type,
            emp.mode_cour,
            -- Activity status 
            case
                when
                    dim_e.last_pay_date >= dateadd(
                        week,
                        -{{
                            var("emp_actif", {"nbrs_sem_dern_paie": 1})[
                                "nbrs_sem_dern_paie"
                            ]
                        }},
                        getdate()
                    )
                then 1
                else 0
            end as is_current
        -- Start from all employees
        from {{ ref("dim_employees") }} as dim_e
        -- Fetch the information from the main job only
        inner join
            {{ ref("i_pai_dos_empl") }} as emp
            on dim_e.matr = emp.matr
            and emp.ind_empl_princ = 1
        inner join {{ ref("i_pai_dos") }} as dos on dim_e.matr = dos.matr
        where
            -- Keep active employees only
            dos.etat_doss = 'A' and emp.date_eff >= '2020-07-01 00:00:00'
    ),

    -- Add permanency status
    permanency as (
        select
            src.matr,
            src.legal_name,
            src.sex_friendly_name,
            src.email_address,
            src.etat,
            src.stat_eng,
            src.corp_empl,
            src.lieu_trav,
            src.type,
            src.mode_cour,
            src.is_current,
            case when perm.code_perm = 1 then 1 else 0 end as is_employee_permanent
        from actives as src
        left join {{ ref("i_pai_dos_perc") }} as perm on src.matr = perm.matr
    ),

    -- Add remuneration metadata
    remuneration as (
        select
            matr,
            legal_name,
            sex_friendly_name,
            email_address,
            etat,
            stat_eng,
            corp_empl,
            lieu_trav,
            type,
            mode_cour,
            is_employee_permanent,
            is_current,
            -- Remuneration type
            case
                when type = 'A' then 'Automatique' when type = 'P' then 'À la pièce'
            end as remuneration_type,
            -- Remuneration Mode
            case
                when mode_cour = 'A'
                then 'Annuel'
                when mode_cour in ('H', 'L')
                then 'Heure'
                when mode_cour = 'E'
                then 'Enseigant(e) - 10 mois'
                when mode_cour = '1'
                then 'Suppléant(e)'
                else 'Autres'
            end as renumeration_mode
        from permanency
    )

-- Add final dimension
select
    src.matr,
    src.legal_name,
    src.sex_friendly_name,
    src.email_address,
    src.is_employee_permanent,
    lieu.workplace_name,
    coalesce(job.code_job_name, 'Inconnu') as job_class,
    coalesce(job.job_group_category, 'Inconnu') as job_department,
    stat.engagement_status_code,
    d_status.employment_status_code,
    -- Status
    stat.is_reg as is_regular,
    src.is_current,
    -- Remuneration
    src.remuneration_type,
    src.renumeration_mode,
    -- Compute derived type_
    case
        when stat.is_reg = 0 and src.type = 'A'
        then 'Temporaire (paie automatique)'
        when stat.is_reg = 0 and src.type = 'P'
        then 'Temporaire (sur pièce)'
        when stat.is_reg = 1
        then 'Régulier'
        else 'Autres'
    end as type_
from remuneration as src
left join {{ ref("dim_mapper_workplace") }} lieu on src.lieu_trav = lieu.workplace
left join {{ ref("dim_mapper_job_group") }} as job on src.corp_empl = job.job_group
left join
    {{ ref("dim_engagement_status_yearly") }} as stat
    on src.stat_eng = stat.stat_eng
    and stat.is_current = 1
left join
    {{ ref("dim_employment_status_yearly") }} as d_status
    on src.etat = d_status.etat_empl
    and d_status.is_current = 1
