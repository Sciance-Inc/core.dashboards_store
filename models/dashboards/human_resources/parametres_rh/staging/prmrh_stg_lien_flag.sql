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
{{ config(alias="stg_lien_flag") }}

with
    base as (
        select
            corp_empl,
            date_deb,
            date_fin,
            row_number() over (partition by corp_empl order by date_fin desc) as rn
        from {{ ref("i_pai_tab_corp_empl_date") }}
        -- on exclut les corps d'emploi qui commencent avec 0 parce qu'ils n'existent
        -- plus
        where corp_empl not like '0%' and date_deb <= getdate()
    ),

    corps_paie as (
        select corp_empl from {{ ref("i_pai_dos_empl") }} group by corp_empl
    ),

    flag_paie_fin as (
        select
            bas.corp_empl,
            bas.date_deb,
            bas.date_fin,
            case when pai.corp_empl is not null then 1 else 0 end as dans_paie,
            case when bas.date_fin <= getdate() then 1 else 0 end as is_termine
        from base as bas
        left join corps_paie as pai on bas.corp_empl = pai.corp_empl
        where bas.rn = 1
    )

select
    map.job_group as corp_empl,
    map.job_group_description as desc_corp_empl,
    map.code_job_name as corp_empl_avec_descr,
    map.job_group_category as categorie,
    flag.date_deb,
    flag.date_fin,
    flag.dans_paie,
    flag.is_termine
from {{ ref("dim_mapper_job_group") }} as map
left join flag_paie_fin as flag on map.job_group = flag.corp_empl
group by
    map.job_group,
    map.job_group_description,
    map.code_job_name,
    map.job_group_category,
    flag.date_deb,
    flag.date_fin,
    flag.dans_paie,
    flag.is_termine
