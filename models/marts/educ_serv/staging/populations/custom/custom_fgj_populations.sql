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
    Create a dummy table with no rows. Actually selecting 0 rows is required as DBT does not support no-data materializations.
    The `adapter.get_relation` pattern can only be used with seeds and not tabLe.

    This table acts as an entry point for the custom population and has to be overrided from the cssXX.data.store.
#}
{% if execute %}
    {{
        log(
            "WARN : custom_fgj_populations is NOT overrided. No custom populations will be added.",
            true,
        )
    }}
{% endif %}

with
    dummy as (
        select
            'FOOBAR' as code_perm,
            1234 as id_eco,
            2023 as annee,
            'custom_1' as population
    )

select top 0 *
from dummy
