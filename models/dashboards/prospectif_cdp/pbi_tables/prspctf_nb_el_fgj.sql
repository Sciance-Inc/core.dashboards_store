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
