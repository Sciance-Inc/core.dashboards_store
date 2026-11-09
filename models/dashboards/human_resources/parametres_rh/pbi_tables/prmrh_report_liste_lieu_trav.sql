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
{{ config(alias="report_liste_lieu_trav") }}

with
    lieux_rh as (
        select distinct lieu_trav, descr, don_loc_12
        from {{ ref("i_pai_tab_lieu_trav") }}
    ),

    poste_affect as (select distinct lieu_trav from {{ ref("i_grh_poste_affect") }}),

    dos_empl as (select distinct lieu_trav from {{ ref("i_pai_dos_empl") }}),

    dos as (select distinct lieu_trav from {{ ref("i_pai_dos") }}),

    habs as (select distinct lieu_trav from {{ ref("i_pai_habs") }}),

    hemp as (select distinct lieu_trav from {{ ref("i_pai_hemp") }}),

    jointures as (
        select
            lrh.lieu_trav,
            lrh.descr,
            case
                when pa.lieu_trav is not null then 'Oui' else 'Non'
            end as existe_grh_poste_affect,
            case
                when de.lieu_trav is not null then 'Oui' else 'Non'
            end as existe_pai_dos_empl,
            case
                when d.lieu_trav is not null then 'Oui' else 'Non'
            end as existe_pai_dos,
            case
                when h.lieu_trav is not null then 'Oui' else 'Non'
            end as existe_pai_habs,
            case
                when he.lieu_trav is not null then 'Oui' else 'Non'
            end as existe_pai_hemp
        from lieux_rh as lrh
        left join poste_affect as pa on lrh.lieu_trav = pa.lieu_trav
        left join dos_empl as de on lrh.lieu_trav = de.lieu_trav
        left join dos as d on lrh.lieu_trav = d.lieu_trav
        left join habs as h on lrh.lieu_trav = h.lieu_trav
        left join hemp as he on lrh.lieu_trav = he.lieu_trav
    )

select
    lieu_trav,
    descr,
    existe_grh_poste_affect,
    existe_pai_dos_empl,
    existe_pai_dos,
    existe_pai_habs,
    existe_pai_hemp
from jointures
where
    existe_grh_poste_affect = 'Non'
    or existe_pai_dos_empl = 'Non'
    or existe_pai_dos = 'Non'
    or existe_pai_habs = 'Non'
    or existe_pai_hemp = 'Non'
