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
            min(annee) as annee,
            matricule,
            corp_empl,
            min(abs_scolaire.gr_paie) as gr_paie,
            lieu_trav,
            pourc_sal,
            categorie,
            min(type_duree) as type_duree,
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
            count(*) as nbr_jours,
            dure

        from {{ ref("stg_absences_scolaires_unpivot") }} as abs_scolaire
        inner join {{ ref("i_pai_tab_cal_jour") }} as cal on cal.date_jour = date
        group by matricule, date, corp_empl, lieu_trav, categorie, pourc_sal, dure
    ),

    -- --------------------------------------------------------------------------------------------------
    -- Agrégation des absences par employé et année
    -- --------------------------------------------------------------------------------------------------
    absences_agregees_employe as (
        select
            min(annee) as annee,
            matricule,
            min(adjs.corp_empl) as corp_empl,
            min(gr_paie) as gr_paie,
            min(lieu_trav) as lieu_trav,
            min(categorie) as categorie,
            max(jds_lundi) as jds_lundi,
            max(jds_mardi) as jds_mardi,
            max(jds_mercredi) as jds_mercredi,
            max(jds_jeudi) as jds_jeudi,
            max(jds_vendredi) as jds_vendredi,
            min(pourc_sal) as pourc_sal,
            min(type_duree) as type_duree,
            min(pourc_sal * dure) / 100.0 as jour,

            case
                when
                    max(cast(hq.poste_specifique as int)) = 1
                    and max(hq.corp_empl) = max(adjs.corp_empl)
                then (sum(pourc_sal * dure) / 100.0) * max(hq.heure)
                else (sum(pourc_sal * dure) / 100.0) * min(hq.heure)
            end as hr_abs,

            case
                when
                    max(cast(hq.poste_specifique as int)) = 1
                    and max(hq.corp_empl) = max(adjs.corp_empl)
                then (sum(pourc_sal * dure) / 100.0) * max(hq.heure) / 1826.3
                else (sum(pourc_sal * dure) / 100.0) * min(hq.heure) / 1826.3
            end as etc_abs,
            date
        from absences_detail_jours_semaine as adjs
        inner join
            {{ ref("heure_quotidienne") }} as hq
            on left(adjs.corp_empl, 1) = hq.categorieemp
        group by matricule, date
    )

select
    abe.annee,
    abe.matricule,
    abe.corp_empl,
    abe.lieu_trav,
    abe.categorie,
    case
        when type_duree = 'duree_courte' then 'Courte durée' else 'Longue durée'
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
    {{ ref("stg_calendrier-jours-eligibles") }} as jr_tr
    on abe.annee = jr_tr.annee
    and abe.gr_paie = jr_tr.gr_paie
