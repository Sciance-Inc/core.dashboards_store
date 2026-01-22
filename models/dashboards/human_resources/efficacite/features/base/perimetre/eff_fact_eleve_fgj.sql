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
with
    source as (
        select
            y_stud.fiche,
            y_stud.annee,
            coalesce(brdg.lieu_jumele, 'Lieu jumelé non configuré') as lieu_jumele,
            case when y_stud.plan_interv_ehdaa = 'Avec' then 1 else 0 end as is_pi,
            y_stud.difficulte as code_difficulte,
            case when y_stud.difficulte is not null then 1 else 0 end as is_difficulte
        from {{ ref("fact_yearly_student") }} y_stud
        join {{ ref("i_gpm_t_eco") }} as eco on y_stud.id_eco = eco.id_eco
        join {{ ref("eff_mapping_fgj_paie") }} as brdg on eco.eco = brdg.ecole_gpi
        join {{ ref('eff_reporting_configuration') }} as config on brdg.lieu_jumele = config.lieu_jumele 
        and config.is_school_comparable = 1
        where y_stud.annee between {{ core_dashboards_store.get_current_year() - 4 }} and {{ core_dashboards_store.get_current_year() - 1 }} 
    )

select
    annee,  -- J'en besoin pour les notes.
    lieu_jumele,
    fiche,
    code_difficulte,
    is_difficulte,
    is_pi
from source
