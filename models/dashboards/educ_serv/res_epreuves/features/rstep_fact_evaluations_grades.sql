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
    Blend together the default and the customs table (not yet implemented)
#}
{{
    config(
        alias="fact_evaluations_grades",
    )
}}

select
    annee,
    ecole,
    fiche,
    friendly_name,
    resultat,
    resultat_numerique,
    -- make the code reussite a boolean to ease the computation of summary statistics
    case when code_reussite = 'R' then 1 else 0 end as cod_reussite,
    -- Create a customly thresolded code reussite.
    case
        when
            resultat_numerique
            >= {{ var("res_epreuves", {"threshold": 70})["threshold"] }}
        then 1
        else 0
    end as cod_reussite_threshold
from {{ ref("rstep_fact_evaluations_grades_from_dim") }}
where resultat_numerique is not null
