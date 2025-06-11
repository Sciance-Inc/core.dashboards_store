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
  Map each school to it's friendly name.

  Feel free to override me to get your own custom litle mapping.
#}
{{
    config(
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["id_eco", "annee"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["school_friendly_name"]
            ),
        ]
    )
}}


select id_eco, annee, eco, concat('(', eco, ') - ', nom_eco) as school_friendly_name
from {{ ref("i_gpm_t_eco") }}
