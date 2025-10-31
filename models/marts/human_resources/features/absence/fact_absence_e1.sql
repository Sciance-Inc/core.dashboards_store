{#
CDPVD Dashboards store
Copyright (C) 2024 CDPVD.

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
{{ config(alias="fact_absence_e1") }}
{{
    config(
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["matricule", "date"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["annee", "gr_paie", "motif_abs"]
            ),
        ],
    )
}}

with
    -- --------------------------------------------------------------------------------------------------
    -- Absences brutes avec contexte
    -- --------------------------------------------------------------------------------------------------
    absences_brutes_avec_contexte as (
        select
            cast(
                year(absence. [date])
                - case when month(absence. [date]) < 7 then 1 else 0 end as varchar(4)
            ) + cast(
                year(absence. [date])
                + case when month(absence. [date]) < 7 then 0 else 1 end as varchar(4)
            ) as annee,
            absence. [matr] as [matricule],
            absence. [date],
            absence.mot_abs as motif_abs,
            absence.lieu_trav as lieu_trav,
            hemp.pourc_sal,
            hemp.gr_paie,
            absence.corp_empl,
            hemp.stat_eng,
            dure,
            -- Code de paiement :103525 => Assurance long terme
            case
                when absence.code_pmnt = 103525 or etat.duree = 1 then 1 else 0
            end as dl,
            case
                when absence.code_pmnt != 103525 and etat.duree != 1 then 1 else 0
            end as cl

        from {{ ref("i_pai_habs") }} as absence

        inner join
            {{ ref("i_pai_hemp") }} as hemp
            on absence.matr = hemp.matr
            and absence.corp_empl = hemp.corp_empl
            and absence.date between hemp.date_eff and hemp.date_fin
            and absence.sect = hemp.sect
            and absence.ref_empl = hemp.ref_empl

        inner join {{ ref("etat_empl") }} as etat on hemp.etat = etat.etat_empl
        where absence.ind_annul = 0 and absence.pourc_indem != 0
    ),

    -- --------------------------------------------------------------------------------------------------
    -- Absences scolaires categorisées
    -- --------------------------------------------------------------------------------------------------
    absences_scolaires_categorisees as (
        select abac.*, jour_sem, typabs.categories
        from absences_brutes_avec_contexte as abac

        inner join
            {{ ref("i_pai_tab_cal_jour") }} as cal
            on abac.annee = cal.an_budg
            and abac.gr_paie = cal.gr_paie
            and abac.date = cal.date_jour

        inner join
            {{ ref("type_absence") }} as typabs on abac.motif_abs = typabs.motif_id

        where
            typabs.statut = 0
            and (jour_sem not in (0, 6))
            and type_jour != 'C'  -- Type_jour C => Congé | On ne le prend pas en compte
            and type_jour != 'E'  -- Type_jour E => Été | On ne le prend pas en compte
            and jour_sem != 0  -- jour_sem 0 => Dimanche | On ne le prend pas en compte
            and jour_sem != 6  -- jour_sem 6 => Samedi | On ne le prend pas en compte
    )

-- --------------------------------------------------------------------------------------------------
-- Unpivot
-- --------------------------------------------------------------------------------------------------
select *
from
    absences_scolaires_categorisees unpivot (valeur for type_duree in (dl, cl)) as unpvt

where valeur != 0
