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
-- La requête SQL extrait une version abrégé de la seed eff_mapping_fgj_paie.
-- C'est pour vous aider a comprendre a bien débuté et comprendre la construction de la seed
-- C'est sans équivaut, vous allez devoir ajuster/modifer la seed.

{% raw %}
select distinct
    p_tab.lieu_trav, -- Lieu de la paie.
    eco.eco, -- Les lieux à null sont généralement des écoles satellites ou des établissements d'administration. 
    null as lieu_jumele -- La colonne doit ABSOLUMENT CONTENIR UN lieu jumelé
from  {{ ref("i_pai_tab_lieu_trav") }} p_tab
left join {{ ref("i_gpm_t_eco") }} eco
    on p_tab.lieu_trav = eco.eco
{% endraw %}