{#
Dashboards Store - Helping students, one dashboard at a time.
Copyright (C) 2025  Sciance Inc.

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
{#
Créer une table factice sans lignes. Il est en fait nécessaire de sélectionner 0 ligne, car DBT ne prend pas en charge les matérialisations sans données.
Le motif adapter.get_relation ne peut être utilisé qu’avec des seeds et non avec une table.

Cette table agit comme point d’entrée pour la population personnalisée "Passe-Partout" et doit être surchargée à partir de cssXX.dashboards_store
#}
{% if execute %}
    {{
        log(
            "WARN : stg_check_passepartout n'est pas surchargé.Il sera pas ajouté dans les populations personnalisées",
            true,
        )
    }}
{% endif %}

with
    dummy as (
        select
            'FOOBAR' as code_perm,
            1234 as id_eco,
            2025 as annee,
            'custom_1' as population,
            0 as is_passepartout
    )

select top 0 *
from dummy