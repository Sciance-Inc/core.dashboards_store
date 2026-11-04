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
{{
    config(
        alias="report_history_stat",
        materialized="incremental",
        full_refresh=false,
        on_schema_change="append_new_columns",
        unique_key=["filter_key", "date_snapshot"],
    )
}}

with

    agg as (
        -- Aller chercher les employés actifs dans la table de base et y ajouter la
        -- date du snapshot
        select *, cast(getdate() as date) as date_snapshot
        from {{ ref("ema_report_stat") }}

    )

select
    date_snapshot,
    total_men,
    total_women,
    total_etp,
    total_men_act,
    total_women_act,
    total_etp_act,
    total_emp_by_group,
    total_emp_by_group_act,
    total_actif,
    emp_cur,
    total_count_emp_act,
    total_count_emp,
    job_department,
    filter_key
from agg
{% if is_incremental() %}
    where
        not exists (
            select 1
            from {{ this }} as h
            where h.date_snapshot = cast(getdate() as date)
        )
{% endif %}
