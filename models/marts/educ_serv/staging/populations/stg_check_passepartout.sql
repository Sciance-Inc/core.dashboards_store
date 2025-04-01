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
            'custom_1' as population
    )

select top 0 *
from dummy
