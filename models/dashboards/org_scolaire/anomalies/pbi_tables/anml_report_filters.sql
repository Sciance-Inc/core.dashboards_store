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
{#
    La table de filters pour le tableau de bord eleves doublons
#}
{{ config(alias="report_filters") }}

-- Prendre des écoles normales avec l'année scolaire pour la filtration
select
    annee,
    school_friendly_name,
    {{ dbt_utils.generate_surrogate_key(["annee", "school_friendly_name"]) }}
    as filter_key
from {{ ref("dim_mapper_schools") }}
where
    id_eco in (
        select popl.id_eco
        from {{ ref("anml_stg_population") }} as popl
        group by popl.id_eco
    )
