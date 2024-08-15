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
-- Extract a rough version of the etat_empl table seed.
-- Of course, this is not the final version of the seed, but it is a good starting
-- point you will need to manually adjust.
{% raw %}
select
    etat_empl,
    descr,
    case when descr like '%retraite%' then 1 else 0 end as empl_retr,
    case when descr like '%congé%' then 1 else 0 end as empl_cong,
    0 as cong_lt,
    1 as etat_actif,
    rel_empl_comm, # REMOVE THE COLUMN FROM THE FINAL SEED FILE AS IT'S JUST A HELPER FOR YOU TO UNDERSTAND THE NATURE OF THE FILED
    null as valid_from,
    null as valid_until
from {{ var("database_paie") }}.dbo.pai_tab_etat_empl {% endraw %}
