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
-- Extract a rough version of the stat_eng table seed.
-- Of course, this is not the final version of the seed, but it is a good starting
-- point you will need to manually adjust.
select
    [stat_eng],
    [descr],
    case when descr like '%Rég%' then 1 else 0 end as is_reg,
    null as valid_from,
    null as valid_until
from {{ var("database_paie") }}.dbo.pai_tab_stat_eng
