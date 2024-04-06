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
    id_eco,
    grille,
    date_evenement,
    jour_cycle,
    {% for i in range(1, 21) %}
        per_{{ "%02d" % i }} {%- if not loop.last %},{% endif -%}
    {% endfor %}
from {{ var("database_gpi") }}.dbo.gpm_t_cal
