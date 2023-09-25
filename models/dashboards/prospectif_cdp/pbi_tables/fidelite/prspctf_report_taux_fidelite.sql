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
{{ config(alias="report_taux_fidelite") }}

select
    annee_budgetaire,
    1 - (
        cast(
            cast(sum(demission_volontaire) as float)
            / cast(count(demission_volontaire) as float) as decimal(5, 5)
        )
    ) as 'ratio_fidelisation'
from {{ ref("prspctf_fact_demission") }}

group by annee_budgetaire
