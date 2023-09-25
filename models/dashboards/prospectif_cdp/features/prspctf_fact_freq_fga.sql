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
{{ config(alias="fact_freq_fga") }}

select
    el.code_perm,
    freq.fiche,
    freq.annee,
    freq.freq,
    freq.date_deb,
    freq.date_fin,
    freq.org,
    freq.eco_cen,
    freq.bat,
    freq.prog,
    prog.descr_prog,
    freq.service_enseign,
    descr.cf_descr
from {{ ref("i_e_freq") }} as freq
left join {{ ref("i_e_ele") }} as el on freq.fiche = el.fiche
left join {{ ref("i_t_prog") }} as prog on freq.prog = prog.prog
left join {{ ref("i_t_wl_descr") }} as descr on freq.service_enseign = descr.code
where
    freq.client = '3'  -- Clientele 3 = FGA
    and freq.date_deb != ''  -- date_deb obligatoire pour chaque CSS?
    and (freq.service_enseign != '' or freq.prog != '')  -- Avoir au moins un de ces 2 champs de ok
    and descr.nom_table = 'X_ServiceEnseign'
