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
{{
    config(
        alias="report_eco",
    )
}}

with
    ecoles as (
        select
            row_number() over (partition by eco order by annee desc) seq_id,
            eco as lieu_trav,
            nom_eco as lieu_trav_desc
        from {{ ref("i_gpm_t_eco") }}

        where
            -- Écoles seulement (les autres ce sont des services)
            eco_off is not null
    )

select *
from ecoles
where seq_id = 1
