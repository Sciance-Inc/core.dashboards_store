{#
dashboards store - helping students, one dashboard at a time.
copyright (c) 2023  sciance inc.

this program is free software: you can redistribute it and/or modify
it under the terms of the gnu affero general public license as
published by the free software foundation, either version 3 of the
license, or any later version.

this program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu affero general public license for more details.

you should have received a copy of the gnu affero general public license
along with this program.  if not, see <https://www.gnu.org/licenses/>.
#}
with adr as (
    select    
        adr.fiche
        , adr.type_adr
        , cast(adr.date_effect as date) as date_effect
        , adr.date_fin
        , adr.ind_envoi_meq                      
        , dim.code_post   
        , row_number() over (partition by fiche order by date_effect) as seqid -- pour identifier la 1ere adresse
    from {{ ref('i_e_adr') }} as adr
    left join {{ ref('dim_adresses') }} as dim
        on dim.no_civ=adr.no_civ and dim.genre_rue=adr.genre_rue and dim.orient_rue=adr.orient_rue and dim.rue=adr.rue and dim.ville=adr.ville

-- dates avec un ind_envoi_meq de 1 (sauf date initiale)
), adr2 as (
    select *
    from adr
    where 
        ind_envoi_meq = 1
        and seqid != 1

-- adresses à considerer
), adr3 as (
    select *
    from adr
    where seqid=1
    union all
    select *
    from adr2

-- modifier les dates effectives avec les adresses conservées
), adr4 as (
    select 
        fiche
        , date_effect
        , case 
            when (lead(date_effect) over(partition by fiche order by date_effect)) is null then getdate() 
            else lead(date_effect) over(partition by fiche order by date_effect)
        end as date_effect_fin
        , code_post
    from adr3

-- identifier les annees scolaire d'appartenance de chaque CP
), y_sco as (
    select 
        fiche
        , date_effect
        , date_effect_fin
        , case when month(date_effect) <= 6 then year(date_effect) - 1 else year(date_effect)
		end as annee_sco_deb
	    , case when  month(date_effect_fin) < 9 then year(date_effect_fin) - 1 else year(date_effect_fin)
		end as annee_sco_fin
        , code_post
    from adr4

-- recuperer les annees scolaire de debut et de fin pour chaque fiche
), tab  as (
    select 
        fiche
        , min(annee_sco_deb) as annee_sco_deb
        , max(annee_sco_fin) as annee_sco_fin
    from y_sco
    group by fiche

-- generer une table fiche/annee et joindre les CP
), long as (
    select 
        t.fiche
        , t.annee_sco_deb + number as annee
    from tab as t
    join master..spt_values n 
        on type = 'p' and number between 0 and t.annee_sco_fin - t.annee_sco_deb
)

select
    long.fiche
    , long.annee
    , y_sco.code_post
    , case when datefromparts(long.annee, 9, 30) between y_sco.date_effect and y_sco.date_effect_fin then 1 else 0 end as adresse_30sept
    , row_number() over (partition by long.fiche, long.annee order by y_sco.date_effect desc) as seqid
from long
left join y_sco
    on y_sco.fiche=long.fiche and long.annee between y_sco.annee_sco_deb and y_sco.annee_sco_fin