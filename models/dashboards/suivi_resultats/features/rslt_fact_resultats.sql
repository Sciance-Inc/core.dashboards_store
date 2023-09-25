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
{{ config(alias="fact_resultats") }}

select
    spi.annee,
    spi.fiche,
    spi.niveau_scolaire,
    dim.course_code,
    dim.course_name,
    dim.course_group,
    res.resultat,
    case when res.resultat_numerique < 60 then 1 else 0 end as is_echec,
    case
        when res.resultat_numerique >= 60 and res.resultat_numerique < 66 then 1 else 0
    end as is_difficulty
-- TODO : add an populate a is_reprise flag
from {{ ref("rslt_stg_spine") }} as spi
left join
    {{ ref("rslt_stg_resultats") }} as res
    on spi.fiche = res.fiche
    and spi.annee = res.annee
inner join
    {{ ref("tracked_courses") }} as dim
    on res.course_code = dim.course_code
    and spi.niveau_scolaire = dim.level  -- Only keep the results for the courses corresponding to the level the student is enrolled in
