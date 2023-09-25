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
select
    fiche,
    annee,
    sk_eleve,
    cod_permanent,
    nom_eleve,
    prenom_eleve,
    nom_prenom_fiche,
    appartement,
    cod_postal,
    moyenne_sommaire,
    dat_naissance_eleve,
    age_30_septembre,
    ind_doubleur,
    ind_plan_intervention_ehdaa,
    cod_difficulte_ehdaa,
    cod_regroupement_ehdaa,
    cod_sexe_eleve,
    cod_cycle,
    cod_annee_cycle,
    cod_niveau_scolaire,
    cod_langue_maternelle,
    cod_ordre_enseignement,
    cod_ecole,
    cod_officiel_ecole,
    cod_groupe_repere,
    cod_distribution,
    cod_classe,
    cod_classification,
    cod_status_dossier,
    cod_religion,
    dat_debut_version,
    dat_debut_frequentation,
    dat_fin_frequentation,
    duree_frequentation_jours,
    des_distribution,
    des_classification,
    cod_motif_fin_frequentation,
    cod_motif_depart,
    ind_repondant_pere,
    ind_repondant_mere,
    ind_repondant_tuteur
from {{ var("database_bi") }}.dbo.dim_eleve
