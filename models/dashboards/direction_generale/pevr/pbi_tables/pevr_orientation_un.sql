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
            '' as nb_resultat,  -- Dummy
            taux as taux_maitrise,
            cible,
            taux_cible,
            '' as id_filtre  -- Dummy
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
    nb_resultat,
    taux_maitrise,
    cible,
    taux_cible,
    id_filtre
from _union
