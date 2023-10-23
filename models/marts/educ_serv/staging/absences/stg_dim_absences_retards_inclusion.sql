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
	This table select the absences reason to include in the computation.
    This file acts a hook for the integrator to exclude the retard from the computation.
    It's designed to be overrided. By default, we include all reasons. 
#}
select id_eco, motif_abs, max(descr) as descr
from {{ ref("i_gpm_t_motif_abs") }}
group by
    id_eco,
    motif_abs
    -- For instance if you wan't to exclude the retard from the downstream
    -- computation, you can, for instance, add the following where clause:
    -- where lower(descr) not like '%retard%'
    
