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
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["fiche", "code_perm"]
            ),
        ]
    )
}}

with spine_keys as (select distinct code_perm, fiche from {{ ref("spine") }})

select
    spi.code_perm,
    spi.fiche,
    -- max(nom) as nom, -- DEBUG : UNUSED IN REPORT
    -- max(pnom) as prenom, -- DEBUG : UNUSED IN REPORT
    concat(max(nom), ', ', max(pnom), ' (', spi.fiche, ' )') as nom_prenom_fiche,  -- dummy aggregation
    -- max(date_naissance) as date_naissance, -- DEBUG : UNUSED IN REPORT
    max(
        case
            when el.sexe = 'F'
            then 'Fille'
            when el.sexe = 'M'
            then 'Garçon'
            else el.sexe
        end
    ) as genre  -- dummy aggregation
from spine_keys as spi
inner join {{ ref("i_gpm_e_ele") }} as el on spi.fiche = el.fiche
group by spi.code_perm, spi.fiche
