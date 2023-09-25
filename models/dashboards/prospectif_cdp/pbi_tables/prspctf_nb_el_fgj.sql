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
{{ config(alias="nb_el_fgj") }}

with
    src as (
        select spi.fiche, spi.population, eco.annee, eco.eco
        from {{ ref("spine") }} as spi
        left join
            {{ ref("i_gpm_t_eco") }} as eco
            on spi.eco = eco.eco
            and spi.annee = eco.annee
        where spi.seqid = 1

    {# Sum the number of students by population #}
    ),
    res as (
        select population, annee, eco, count(fiche) as nb_eleves
        from src
        group by annee, eco, population

    {# Total sum #}
    ),
    tot as (select annee, eco, sum(nb_eleves) as nb_eleves from res group by annee, eco)

select *
from res
union
select 'all' as population, annee, eco, nb_eleves
from tot
