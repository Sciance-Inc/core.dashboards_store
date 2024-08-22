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
-- Extract a rough version of the volumetrie table. 
-- We advise you to plug this table into excel to help you define your populations
{% raw %}
with
    src as (
        select
            dan.statut_don_an,
            dan.ordre_ens,
            dan.classe,
            dan.class as code_classification,
            dan.dist as code_distribution,
            dan.grp_rep as code_groupe_repere,
            eco.annee,
            eco.eco,
            eco.nom_eco,
            ele.code_perm as code_permanent
        from {{ ref("i_gpm_e_dan") }} as dan
        join {{ ref("i_gpm_e_ele") }} as ele on dan.fiche = ele.fiche
        join {{ ref("i_gpm_t_eco") }} as eco on dan.id_eco = eco.id_eco
    ),
    agg as (
        select
            ordre_ens,
            classe,
            code_classification,
            code_distribution,
            code_groupe_repere,
            annee,
            eco,
            statut_don_an,
            max(nom_eco) as nom_eco,
            count(distinct src.code_permanent) as n_code_permanents
        from src
        group by
            statut_don_an,
            ordre_ens,
            classe,
            code_classification,
            code_distribution,
            code_groupe_repere,
            annee,
            eco
    )

select
    ordre_ens,
    case
        when ordre_ens in ('1', '2')
        then 'prescolaire'
        when ordre_ens = '3'
        then 'primaire'
        when ordre_ens = '4'
        then 'secondaire'
        else 'autre'
    end as ordre_ens_friendly,
    classe,
    code_classification,
    code_distribution,
    code_groupe_repere,
    annee,
    eco,
    statut_don_an,
    nom_eco,
    n_code_permanents
from agg {% endraw %}
