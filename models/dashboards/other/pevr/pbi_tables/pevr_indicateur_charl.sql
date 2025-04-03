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
{{ config(alias="indicateur_charl") }}

with
    val_depart as (
        select
            ind.objectif,
            coalesce(ind.id_indicateur_css, ind.id_indicateur_meq) id_indicateur,
            ind.description_indicateur,
            case
                when cib.annee_scolaire = '2022 - 2023'
                then 'Valeur de départ'
                else cib.annee_scolaire
            end as annee_scolaire,
            taux,
            cib.cible,
            case
                when taux is null
                then concat('(', cast(cible * 100 as decimal(5, 1)), '%)')
                else
                    concat(
                        cast(taux * 100 as decimal(5, 1)),
                        '% (',
                        cast(cible * 100 as decimal(5, 1)),
                        '%)'
                    )
            end as taux_cible
        from {{ ref("pevr_dim_indicateur_charl") }} cib
        left join
            {{ ref("pevr_dim_indicateurs") }} as ind
            on ind.id_indicateur_meq = cib.id_indicateur_meq
    )
select
    objectif,
    id_indicateur,
    description_indicateur,
    annee_scolaire,
    taux,
    cible,
    case
        when annee_scolaire = 'Valeur de départ'
        then concat(cast(taux * 100 as decimal(5, 1)), '%')
        else taux_cible
    end as taux_cible
from val_depart
