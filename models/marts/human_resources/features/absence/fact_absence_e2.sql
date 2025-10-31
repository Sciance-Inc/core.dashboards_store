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
{{
    config(
        materialized="table",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["annee", "gr_paie"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["matricule", "date", "corp_empl"]
            ),
        ],
    )
}}


with
    -- --------------------------------------------------------------------------------------------------
    -- Répartition des absences par jour de semaine (pondérées par % salaire)
    -- --------------------------------------------------------------------------------------------------
    absences_detail_jours_semaine as (
        select
            annee,
            matricule,
            corp_empl,
            e2.gr_paie,
            lieu_trav,
            pourc_sal,
            categories,
            dure,
            stat_eng,
            type_duree,
            date,
            sum(
                case
                    when cal.jour_sem = 1 then ((pourc_sal * dure) / 100) / 7 else 0
                end
            ) as jds_lundi,
            sum(
                case
                    when cal.jour_sem = 2 then ((pourc_sal * dure) / 100) / 7 else 0
                end
            ) as jds_mardi,
            sum(
                case
                    when cal.jour_sem = 3 then ((pourc_sal * dure) / 100) / 7 else 0
                end
            ) as jds_mercredi,
            sum(
                case when cal.jour_sem = 4 then ((pourc_sal * dure) / 100) / 7 end
            ) as jds_jeudi,
            sum(
                case
                    when cal.jour_sem = 5 then ((pourc_sal * dure) / 100) / 7 else 0
                end
            ) as jds_vendredi,
            count(*) as nbr_jours
        from {{ ref("fact_absence_e1") }} as e2

        inner join {{ ref("i_pai_tab_cal_jour") }} as cal on cal.date_jour = date

        group by
            annee,
            matricule,
            corp_empl,
            e2.gr_paie,
            stat_eng,
            type_duree,
            lieu_trav,
            pourc_sal,
            categories,
            dure,
            date
    ),

    -- --------------------------------------------------------------------------------------------------
    -- Agrégation des absences par employé et année
    -- --------------------------------------------------------------------------------------------------
    absences_agregees_employe as (
        select
            annee,
            matricule,
            corp_empl,
            gr_paie,
            lieu_trav,
            categories,
            jds_lundi,
            jds_mardi,
            jds_mercredi,
            jds_jeudi,
            jds_vendredi,
            pourc_sal,
            type_duree,
            sum(pourc_sal * dure) / 100.0 as jour,
            (sum(pourc_sal * dure) / 100.0) * 7 as hr_abs,
            ((sum(pourc_sal * dure) / 100.0) * 7) / 1826.3 as etc_abs,
            date
        from absences_detail_jours_semaine
        group by
            annee,
            matricule,
            corp_empl,
            gr_paie,
            lieu_trav,
            categories,
            type_duree,
            jds_lundi,
            jds_mardi,
            jds_mercredi,
            jds_jeudi,
            jds_vendredi,
            pourc_sal,
            date,
            dure
    )

select
    abe.annee,
    abe.matricule,
    abe.corp_empl,
    abe.lieu_trav,
    abe.categories,
    case
        when type_duree = 'cl' then 'Courte durée' else 'Longue durée'
    end as duree_descr,
    abe.jour as jour_absence,
    jr_tr.jour_trav as jour_travaille,
    abe.jds_lundi,
    abe.jds_mardi,
    abe.jds_mercredi,
    abe.jds_jeudi,
    abe.jds_vendredi,
    abe.date,
    abe.gr_paie,
    etc_abs,
    hr_abs
from absences_agregees_employe as abe
inner join
    {{ ref("fact_absence_e0") }} as jr_tr
    on abe.annee = jr_tr.annee
    and abe.gr_paie = jr_tr.gr_paie
