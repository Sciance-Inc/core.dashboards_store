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
{{ config(alias="orientation_un") }}

with
    _union as (
        select
            objectif,
            id_indicateur,
            description_indicateur,
            'Jade' as source,
            annee_scolaire,
            null as nb_resultat,  -- Field not present in pevr_indicateur_charl; set to null for schema alignment in union
            taux as taux_maitrise,
            cible,
            taux_cible,
            null as id_filtre  -- Field not present in pevr_indicateur_charl; set to null for schema alignment in union
        from {{ ref("pevr_indicateur_charl") }}
        where id_indicateur like '1.1.1%'
        union
        select
            objectif,
            id_indicateur,
            description_indicateur,
            'GPI' as source,
            annee_scolaire,
            nb_resultat,
            taux_maitrise,
            cible,
            taux_cible,
            id_filtre
        from {{ ref("pevr_indicateur_epreuves") }}
        where id_indicateur like '1.1.1%'
    )

select
    objectif,
    id_indicateur,
    description_indicateur,
    source,
    annee_scolaire,
    case
        when annee_scolaire = 'Valeur de départ'
        then 1
        when annee_scolaire = '2023 - 2024'
        then 2
        when annee_scolaire = '2024 - 2025'
        then 3
        when annee_scolaire = '2025 - 2026'
        then 4
        when annee_scolaire = '2026 - 2027'
        then 5
        else 0
    end as tri_annee,
    nb_resultat,
    taux_maitrise,
    cible,
    taux_cible,
    id_filtre
from _union
