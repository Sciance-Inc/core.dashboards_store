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

{% set AssurangeLongTerme = var("dashboards")["emp_abs"]["code_paiement"] %}

with
    -- --------------------------------------------------------------------------------------------------
    -- Absences brutes avec contexte
    -- --------------------------------------------------------------------------------------------------
    absences_brutes_avec_contexte as (
        select
            cast(
                year(absence.date)
                - case when month(absence.date) < 7 then 1 else 0 end as varchar(4)
            ) + cast(
                year(absence.date)
                + case when month(absence.date) < 7 then 0 else 1 end as varchar(4)
            ) as annee,
            absence.matr as matricule,
            absence.date,
            absence.mot_abs as motif_abs,
            absence.lieu_trav as lieu_trav,
            hemp.pourc_sal,
            hemp.gr_paie,
            absence.corp_empl,
            hemp.stat_eng,
            dure,

            case
                when
                    absence.code_pmnt in ({{ AssurangeLongTerme | join(", ") }})
                    or etat.type_duration = 1
                then 1
                else 0
            end as duree_longue,
            case
                when
                    absence.code_pmnt not in ({{ AssurangeLongTerme | join(", ") }})
                    and etat.type_duration != 1
                then 1
                else 0
            end as duree_courte

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
        select abac.*, typabs.categorie
        from absences_brutes_avec_contexte as abac

        inner join
            {{ ref("stg_calendrier-jours-eligibles") }} as jr_tr
            on abac.annee = jr_tr.annee
            and abac.gr_paie = jr_tr.gr_paie

        inner join
            {{ ref("type_absence") }} as typabs on abac.motif_abs = typabs.motif_id

        where typabs.statut = 0
    )

-- --------------------------------------------------------------------------------------------------
-- Unpivot
-- --------------------------------------------------------------------------------------------------
select *
from
    absences_scolaires_categorisees
    unpivot (valeur for type_duree in (duree_longue, duree_courte)) as unpvt

where valeur != 0
