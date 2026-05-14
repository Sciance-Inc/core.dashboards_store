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
                "{{ this }}", ["annee", "gr_paie"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["matricule", "date_abs", "corp_empl"]
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
            min(annee) as annee,
            matricule,
            corp_empl,
            min(abs_scolaire.gr_paie) as gr_paie,
            lieu_trav,
            pourc_sal,
            categorie,
            min(type_duree) as type_duree,
            abs_scolaire.date_abs,
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
                case
                    when cal.jour_sem = 4 then ((pourc_sal * dure) / 100) / 7 else 0
                end
            ) as jds_jeudi,
            sum(
                case
                    when cal.jour_sem = 5 then ((pourc_sal * dure) / 100) / 7 else 0
                end
            ) as jds_vendredi,
            count(*) as nbr_jours,
            dure
        from {{ ref("stg_absences_scolaires_unpivot") }} as abs_scolaire
        inner join
            {{ ref("i_pai_tab_cal_jour") }} as cal
            on cal.date_jour = abs_scolaire.date_abs
        group by
            matricule,
            abs_scolaire.date_abs,
            corp_empl,
            lieu_trav,
            categorie,
            pourc_sal,
            dure
    ),

    -- --------------------------------------------------------------------------------------------------
    -- Agrégation des absences par employé et année
    -- --------------------------------------------------------------------------------------------------
    absences_agregees_employe as (
        select
            annee as annee,
            matricule,
            adjs.corp_empl as corp_empl,
            gr_paie as gr_paie,
            lieu_trav as lieu_trav,
            categorie as categorie,
            jds_lundi as jds_lundi,
            jds_mardi as jds_mardi,
            jds_mercredi as jds_mercredi,
            jds_jeudi as jds_jeudi,
            jds_vendredi as jds_vendredi,
            pourc_sal as pourc_sal,
            type_duree as type_duree,
            pourc_sal * dure / 100.0 as jour,
            date_abs
        from absences_detail_jours_semaine as adjs
    )

select
    min(abe.annee) as annee,
    abe.matricule,
    min(abe.corp_empl) as corp_empl,
    min(abe.lieu_trav) as lieu_trav,
    min(abe.categorie) as categorie,
    case
        when min(type_duree) = 'duree_courte' then 'Courte durée' else 'Longue durée'
    end as duree_descr,
    min(abe.jour) as jour_absence,
    min(abe.jds_lundi) as jds_lundi,
    min(abe.jds_mardi) as jds_mardi,
    min(abe.jds_mercredi) as jds_mercredi,
    min(abe.jds_jeudi) as jds_jeudi,
    min(abe.jds_vendredi) as jds_vendredi,
    abe.date_abs,
    min(abe.gr_paie) as gr_paie,
    case
        when
            max(cast(hq.poste_specifique as int)) = 1
            and max(hq.corp_empl) = max(abe.corp_empl)
        then min(abe.jour) * min(hq.heure)
        else min(abe.jour) * min(hq.heure)
    end as hr_abs,
    case
        when
            max(cast(hq.poste_specifique as int)) = 1
            and max(hq.corp_empl) = max(abe.corp_empl)
        then min(abe.jour) * min(hq.heure) / 1826.3
        else min(abe.jour) * min(hq.heure) / 1826.3
    end as etc_abs
from absences_agregees_employe as abe
inner join
    {{ ref("heure_quotidienne") }} as hq on left(abe.corp_empl, 1) = hq.categorie_emp
group by matricule, date_abs
