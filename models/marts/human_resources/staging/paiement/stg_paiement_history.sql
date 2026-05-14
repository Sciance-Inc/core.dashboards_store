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
with
    source as (select matr as matricule, no_cheq from {{ ref("i_pai_hchq") }}),

    stg_activity as (
        select
            ah.matr,
            ah.school_year,
            ah.ref_empl,
            ah.corp_empl,
            ah.etat_empl,
            ah.stat_eng,
            ah.lieu_trav,
            ah.date_eff,
            ah.date_fin,
            hc.nb_hres_an,
            hc.nb_hres_jrs
        from {{ ref("stg_activity_history") }} ah
        left join
            {{ ref("stg_hrs_calc") }} hc
            on ah.corp_empl = hc.corp_empl
            and ah.stat_eng = hc.stat_eng
    ),

    -- Table d'historique des employés
    stg_hist_source as (
        select
            stg.matr as matricule,
            stg.ref_empl,
            stg.corp_empl,
            stg.etat_empl,
            stg.stat_eng,
            coalesce(mp.lieu_jumele, 'Lieu jumelé non configuré') as lieu_jumele,
            min(date_eff) as date_debut_historique,
            max(date_fin) as date_fin_historique,
            max(stg.nb_hres_an) as nb_hres_an,  -- Dummy
            max(stg.nb_hres_jrs) as nb_hres_jrs  -- Dummy
        from stg_activity stg
        left join {{ ref("eff_mapping_fgj_paie") }} mp on stg.lieu_trav = mp.lieu_trav
        where stg.lieu_trav is not null  -- Enlève les paiement sans lieu de travail dans l'historique.
        group by
            stg.matr,
            stg.ref_empl,
            stg.corp_empl,
            stg.etat_empl,
            stg.stat_eng,
            mp.lieu_jumele,
            stg.lieu_trav
    ),

    -- Table des paiements
    grp_paiement as (
        select
            s.matricule,
            s.no_cheq,
            p.code_pmnt,
            p.mode_paiement,
            p.code_provenance,
            p.ref_empl,
            p.corp_empl,
            mp.lieu_jumele,
            sum(p.nb_unit) as nb_unit,
            sum(p.mnt) as total_mnt_brut,
            min(p.date_deb) as date_debut_paiement,
            max(p.date_fin) as date_fin_paiement,
            min(p.date_cheq) as date_cheq_paiement
        from source s
        left join
            {{ ref("i_pai_hchq_pmnt") }} p
            on s.matricule = p.matr
            and s.no_cheq = p.no_cheq
        left join
            {{ ref("eff_mapping_fgj_paie") }} mp  -- Lien avec les écoles dites jumulé
            on p.lieu_trav = mp.lieu_trav
        where code_pmnt is not null  -- Enlève les déductions non présent dans grp_paiement
        group by
            s.matricule,
            s.no_cheq,
            p.code_pmnt,
            p.mode_paiement,
            p.code_provenance,
            p.ref_empl,
            p.corp_empl,
            mp.lieu_jumele
    ),

    -- Création d'un uuid pour un fuzzy join
    paiement_id as (
        select *, row_number() over (order by matricule) as uuid_ from grp_paiement
    ),

    -- left join sur hist pour avoir l'ecart de la date de paiement le plus récent sur
    -- une période d'historique
    stg_hist_join as (
        select
            pid.matricule,
            pid.no_cheq,
            pid.code_pmnt,
            pid.ref_empl,
            pid.mode_paiement,
            pid.code_provenance,
            max(coalesce(pid.corp_empl, hs.corp_empl)) as corp_empl,  -- Priorise la donnée de l'historique de paiement
            max(coalesce(pid.lieu_jumele, hs.lieu_jumele)) as lieu_jumele,  -- Priorise la donnée de l'historique de paiement
            max(pid.total_mnt_brut) as total_mnt_brut,
            sum(
                case
                    when
                        pid.code_pmnt = '105001'
                        and pid.code_provenance in ('AX', 'AY', 'A0')
                    then
                        case
                            when pid.mode_paiement in ('1', '5', 'J')
                            then hs.nb_hres_jrs * pid.nb_unit
                            when pid.mode_paiement in ('H', 'L', '2')
                            then pid.nb_unit
                            when pid.mode_paiement in ('G', 'M', '6', 'E')
                            then nullif(pid.nb_unit, 0) / 60
                            when pid.mode_paiement = 'P'
                            then (pid.nb_unit * hs.nb_hres_an) / nullif(1000, 0)
                            when pid.mode_paiement = 'F'
                            then (pid.nb_unit * hs.nb_hres_an) / nullif(720, 0)
                            when pid.mode_paiement = 'D'
                            then (pid.nb_unit * hs.nb_hres_an) / nullif(800, 0)
                            when pid.mode_paiement = '3'
                            then (pid.nb_unit * hs.nb_hres_jrs) / nullif(2, 0)
                            when pid.mode_paiement = '4'
                            then (pid.nb_unit * hs.nb_hres_jrs) * 0.75
                        end
                    when
                        pid.mode_paiement in (
                            '1',
                            '5',
                            'J',
                            'H',
                            'L',
                            '2',
                            'G',
                            'M',
                            '6',
                            'E',
                            'P',
                            'F',
                            'D',
                            '3',
                            '4'
                        )
                        and pid.code_provenance not in (
                            'A6', 'AJ', 'AW', 'AK', 'A5', 'AL', 'AT', 'AV', 'AS', 'AU'
                        )
                        and pid.code_pmnt not like '2%'
                        and pid.code_pmnt not like '105%'
                    then
                        case
                            when pid.mode_paiement in ('1', '5', 'J')
                            then hs.nb_hres_jrs * pid.nb_unit
                            when pid.mode_paiement in ('H', 'L', '2')
                            then pid.nb_unit
                            when pid.mode_paiement in ('G', 'M', '6', 'E')
                            then nullif(pid.nb_unit, 0) / 60
                            when pid.mode_paiement = 'P'
                            then (pid.nb_unit * hs.nb_hres_an) / nullif(1000, 0)
                            when pid.mode_paiement = 'F'
                            then (pid.nb_unit * hs.nb_hres_an) / nullif(720, 0)
                            when pid.mode_paiement = 'D'
                            then (pid.nb_unit * hs.nb_hres_an) / nullif(800, 0)
                            when pid.mode_paiement = '3'
                            then (pid.nb_unit * hs.nb_hres_jrs) / nullif(2, 0)
                            when pid.mode_paiement = '4'
                            then (pid.nb_unit * hs.nb_hres_jrs) * 0.75
                        end
                end
            ) as hrs_remunere,
            min(pid.date_debut_paiement) as date_debut_paiement,
            max(pid.date_fin_paiement) as date_fin_paiement,
            min(hs.date_debut_historique) as date_debut_historique,
            hs.etat_empl,
            hs.stat_eng,
            max(pid.date_cheq_paiement) as date_cheq_paiement,
            min(
                datediff(day, pid.date_fin_paiement, hs.date_debut_historique)
            ) as ecart,  -- créer un ranking sur la donnée la plus récente.
            pid.uuid_
        from paiement_id pid
        left join
            stg_hist_source hs
            on pid.matricule = hs.matricule
            and pid.ref_empl = hs.ref_empl
            and pid.date_fin_paiement >= hs.date_debut_historique
        group by
            pid.matricule,
            pid.no_cheq,
            pid.code_pmnt,
            pid.code_provenance,
            pid.ref_empl,
            pid.mode_paiement,
            hs.etat_empl,
            hs.stat_eng,
            pid.uuid_
    ),

    -- Utilisation du uuid avec un order by ecart desc pour prendre la période de
    -- paiement la plus récent en rapport de la date d'historique.
    _row_num as (
        select *, row_number() over (partition by uuid_ order by ecart desc) as rn
        from stg_hist_join
    ),

    -- CTE qui flag les corps empl enseignant ayant un paiement sans emploi actif
    _flaggedteacher as (
        select
            *,
            case
                when
                    corp_empl like '3%'
                    and month(date_fin_paiement) = 8
                    and ecart is null  -- Surtout au début de l'année scolaire, donc mois = 8
                then 1
                else 0
            end as isflagged  -- On exclu quelques enseignants/secrétaire à cause du mois et également du corps empl
        from _row_num
        where rn = 1
    ),

    -- On refait la liaison avec la table historique avec un coalesce pour reprendre
    -- la période le plus près du paiement
    _flagged_hist as (
        select
            ft.matricule,
            ft.no_cheq,
            ft.code_pmnt,
            ft.mode_paiement,
            ft.code_provenance,
            ft.ref_empl,
            ft.corp_empl,
            ft.total_mnt_brut,
            ft.hrs_remunere,
            ft.date_debut_paiement,
            ft.date_fin_paiement,
            coalesce(ft.date_fin_paiement, hs.date_fin_historique) as date_fin_periode,
            coalesce(ft.etat_empl, hs.etat_empl) as etat_empl,
            coalesce(ft.lieu_jumele, hs.lieu_jumele) as lieu_jumele,
            coalesce(ft.stat_eng, hs.stat_eng) as stat_eng,
            ft.date_cheq_paiement,
            datediff(day, ft.date_fin_paiement, hs.date_debut_historique) as ecart,
            ft.uuid_
        from _flaggedteacher ft
        left join
            stg_hist_source hs
            on ft.matricule = hs.matricule
            and ft.ref_empl = hs.ref_empl
            and ft.date_fin_paiement = dateadd(day, -1, hs.date_debut_historique)
            and isflagged = 1
    ),

    ann_sco as (
        select
            case  -- Voir pour créer une macro?
                when month(date_cheq_paiement) between 1 and 6
                then cast(year(date_cheq_paiement) - 1 as integer)
                else cast(year(date_cheq_paiement) as integer)
            end as annee,
            matricule,
            no_cheq,
            code_pmnt,
            mode_paiement,
            code_provenance,
            ref_empl,
            corp_empl,
            total_mnt_brut,
            hrs_remunere,
            -- date_debut_paiement,
            -- date_fin_paiement,
            date_fin_periode,
            etat_empl,
            lieu_jumele,
            stat_eng,
            date_cheq_paiement
        from _flagged_hist
    )

-- Champ en commentaire pour utilisation future
select
    annee,
    matricule,
    no_cheq,
    code_pmnt,
    -- mode_paiement,
    -- code_provenance,
    ref_empl,
    corp_empl,
    total_mnt_brut,
    hrs_remunere,
    -- date_debut_paiement,
    -- date_fin_paiement,
    date_fin_periode,
    etat_empl,
    lieu_jumele,
    stat_eng,
    date_cheq_paiement
from ann_sco
