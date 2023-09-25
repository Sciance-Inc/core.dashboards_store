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
{{ config(alias="nb_el_fga") }}

with
    src as (
        select code_perm, annee, eco_cen, date_deb, date_fin
        from {{ ref("prspctf_fact_freq_fga") }}
        where date_fin = ''

    )

{# Sum the number of students by population #}
select annee, eco_cen, count(distinct code_perm) as nb_eleves
from src
group by annee, eco_cen
