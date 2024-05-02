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
{% set max_etapes = var("interfaces")["gpi"]["max_etapes"] + 1 %}
{% set years_of_data_grades = var("marts")["educ_serv"]["recency"][
    "years_of_data_grades"
] %}

-- To reduce the number of rows to be casted as nvarchar, I first filter down the data
-- to the last n years through a join on the school year table
select
    ele.id_mat_ele,
    ele.id_mat_grp,
    ele.fiche,
    ele.id_eco,
    ele.mat,
    ele.grp,
    ele.etat,
    ele.res_meq,
    ele.r100_meq,
    ele.unites_ele,
    ele.res_som,
    ele.res_pond_som,
    ele.pond_som,
    {% for i in range(1, max_etapes) %}
        cast(ele.res_etape_{{ "%02d" % i }} as nvarchar) as res_etape_{{ "%02d" % i }},
    {% endfor %}
    {% for i in range(1, max_etapes) %}
        cast(
            ele.res_pond_etape_{{ "%02d" % i }} as nvarchar
        ) as res_pond_etape_{{ "%02d" % i }},
    {% endfor %}
    ele.type_form_mat,
    ele.rem,
    ele.res_som_etapes,
    ele.res_som_calc,
    ele.jugement,
    ele.reprise,
    ele.modele_etape,
    ele.mois_sanction
from {{ var("database_gpi") }}.dbo.gpm_e_mat_ele as ele
inner join
    {{ ref("i_gpm_t_eco") }} as eco
    on eco.id_eco = ele.id_eco
    and eco.annee >= {{ store.get_current_year() }} - {{ years_of_data_grades }}
