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
{{ config(alias="portrait_eleve") }}

with
    src_tab as (
        select
            el.fiche,
            el.nom_prenom_fiche,
            el.population,
            el.eco,
            el.nom_ecole,
            el.annee,
            el.niveau_scolaire,
            el.grp_rep,
            el.is_doubleur,
            el.plan_interv_ehdaa,
            el.difficulte,
            el.type_mesure,
            el.age_30_sept,
            el.particularite_sante,
            el.recommandations,
            el.mesure_30810,
            el.dist,
            -- , el.besoin_ressources
            code_matiere,
            des_matiere,
            -- , groupe_matiere
            niveau_res,
            no_comp,
            res_num_comp,
            is_current_year,
            is_previous_year,
            is_echec_course_current,
            is_diff_course_current,
            is_echec_course_previous,
            is_diff_course_previous,
            is_maitrise_course_current,
            is_maitrise_course_previous
        from {{ ref("srslt_report_suivi_resultats") }} as res
        inner join
            {{ ref("fact_yearly_student") }} as el
            on res.fiche = el.fiche
            and res.eco = el.eco
            and res.annee = el.annee
        where
            des_matiere like 'ANG%'
            or des_matiere like 'FRA%'
            or des_matiere like 'MAT%'
    ),
    piv_tab as (
        select
            fiche,
            nom_prenom_fiche,
            population,
            eco,
            nom_ecole,
            annee,
            niveau_scolaire,
            grp_rep,
            is_doubleur,
            plan_interv_ehdaa,
            difficulte,
            type_mesure,
            age_30_sept,
            particularite_sante,
            recommandations,
            mesure_30810,
            -- , besoin_ressources     
            dist,
            niveau_res,
            -- , groupe_matiere
            max(lire) as lire,
            max(écrire) as écrire,
            max(résoudre) as résoudre,
            max(raisonner) as raisonner,
            max(communiquer) as communiquer,
            max(comprendre) as comprendre
        from
            (
                select
                    fiche,
                    nom_prenom_fiche,
                    population,
                    eco,
                    nom_ecole,
                    annee,
                    niveau_scolaire,
                    grp_rep,
                    is_doubleur,
                    plan_interv_ehdaa,
                    difficulte,
                    type_mesure,
                    age_30_sept,
                    particularite_sante,
                    recommandations,
                    mesure_30810,
                    -- , besoin_ressources      
                    dist,
                    niveau_res,
                    -- , groupe_matiere
                    case
                        when (des_matiere like 'FRA%' and no_comp = 1) then res_num_comp
                    end as 'Lire',
                    case
                        when (des_matiere like 'FRA%' and no_comp = 2) then res_num_comp
                    end as 'Écrire',
                    case
                        when (des_matiere like 'MAT%' and no_comp = 1) then res_num_comp
                    end as 'Résoudre',
                    case
                        when (des_matiere like 'MAT%' and no_comp = 2) then res_num_comp
                    end as 'Raisonner',
                    case
                        when
                            (
                                des_matiere like 'ANG%'
                                and (
                                    code_matiere != 'ANG100'
                                    and code_matiere != 'ANG200'
                                )
                                and no_comp = 1
                            )
                            or (
                                (code_matiere = 'ANG100' or code_matiere = 'ANG200')
                                and no_comp = 2
                            )
                        then res_num_comp
                    end as 'Communiquer',
                    case
                        when
                            (des_matiere like 'ANG%' and no_comp = 2)
                            or (
                                (code_matiere = 'ANG100' or code_matiere = 'ANG200')
                                and no_comp = 1
                            )
                        then res_num_comp
                    end as 'Comprendre'
                from src_tab
            ) as srctable
        group by
            fiche,
            nom_prenom_fiche,
            population,
            eco,
            nom_ecole,
            annee,
            niveau_scolaire,
            grp_rep,
            is_doubleur,
            plan_interv_ehdaa,
            difficulte,
            type_mesure,
            age_30_sept,
            particularite_sante,
            recommandations,
            mesure_30810,
            -- , besoin_ressources      
            dist,
            -- , groupe_matiere
            niveau_res

    )

select
    fiche,
    nom_prenom_fiche,
    population,
    eco,
    nom_ecole,
    annee,
    niveau_scolaire,
    grp_rep,
    is_doubleur,
    plan_interv_ehdaa,
    difficulte,
    type_mesure,
    age_30_sept,
    case
        when particularite_sante is null then 'Non' else 'Oui'
    end as particularite_sante,
    recommandations,
    case
        when mesure_30810 is null or mesure_30810 = '0' then 'Non' else 'Oui'
    end as mesure_30810,
    dist,
    niveau_res,
    -- , groupe_matiere    
    -- résultats compétences    
    lire,
    écrire,
    résoudre,
    raisonner,
    communiquer,
    comprendre,
    -- indice echec    
    case when lire < 60 then 'Oui' else 'Non' end is_echec_lecture,
    case when écrire < 60 then 'Oui' else 'Non' end is_echec_écrire,
    case
        when lire < 60 and écrire < 60 then 'Oui' else 'Non'
    end is_echec_lecture_écrire,
    case when résoudre < 60 then 'Oui' else 'Non' end is_echec_résoudre,
    case when raisonner < 60 then 'Oui' else 'Non' end is_echec_raisonner,
    case
        when résoudre < 60 and raisonner < 60 then 'Oui' else 'Non'
    end is_echec_raisonner_résoudre,
    case when comprendre < 60 then 'Oui' else 'Non' end is_echec_comprendre,
    case when communiquer < 60 then 'Oui' else 'Non' end is_echec_communiquer,
    case
        when comprendre < 60 and écrire < 60 then 'Oui' else 'Non'
    end is_echec_communiquer_comprendre,
    -- indice diff    
    case when lire >= 60 and lire < 70 then 'Oui' else 'Non' end is_diff_lecture,
    case when écrire >= 60 and écrire < 70 then 'Oui' else 'Non' end is_diff_écrire,
    case
        when lire >= 60 and lire < 70 and écrire >= 60 and écrire < 70
        then 'Oui'
        else 'Non'
    end is_diff_lecture_écrire,
    case
        when résoudre >= 60 and résoudre < 70 then 'Oui' else 'Non'
    end is_diff_résoudre,
    case
        when raisonner >= 60 and raisonner < 70 then 'Oui' else 'Non'
    end is_diff_raisonner,
    case
        when résoudre >= 60 and résoudre < 70 and raisonner >= 60 and raisonner < 70
        then 'Oui'
        else 'Non'
    end is_diff_raisonner_résoudre,
    case
        when comprendre >= 60 and comprendre < 70 then 'Oui' else 'Non'
    end is_diff_comprendre,
    case
        when communiquer >= 60 and communiquer < 70 then 'Oui' else 'Non'
    end is_diff_communiquer,
    case
        when
            comprendre >= 60
            and comprendre < 70
            and communiquer >= 60
            and communiquer < 70
        then 'Oui'
        else 'Non'
    end is_diff_communiquer_comprendre,
    -- indice maitrise
    case when lire >= 70 then 'Oui' else 'Non' end is_maitrise_lecture,
    case when écrire >= 70 then 'Oui' else 'Non' end is_maitrise_écrire,
    case
        when lire >= 70 and écrire >= 70 then 'Oui' else 'Non'
    end is_maitrise_lecture_écrire,
    case when résoudre >= 70 then 'Oui' else 'Non' end is_maitrise_résoudre,
    case when raisonner >= 70 then 'Oui' else 'Non' end is_maitrise_raisonner,
    case
        when résoudre >= 70 and raisonner >= 70 then 'Oui' else 'Non'
    end is_maitrise_raisonner_résoudre,
    case when comprendre >= 70 then 'Oui' else 'Non' end is_maitrise_comprendre,
    case when communiquer >= 70 then 'Oui' else 'Non' end is_maitrise_communiquer,
    case
        when comprendre >= 70 and communiquer >= 70 then 'Oui' else 'Non'
    end is_maitrise_communiquer_comprendre

from piv_tab
