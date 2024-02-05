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
    select distinct    
        fiche
        , date_effect
        , ind_envoi_meq                            
        , code_post
        , row_number() over (partition by fiche, date_effect order by ind_envoi_meq desc) as seqid   -- si 2 adresses, on privilegie celles qui est envoyé au meq     
    from {{ ref('i_e_adr') }}

-- ajout d'une date de fin pour chaque adresse
), dat as (
    select    
        fiche
        , date_effect  
        , lead(date_effect) over (partition by fiche order by date_effect) as date_effect_fin
        , ind_envoi_meq                        
        , code_post
    from adr
    where seqid = 1

-- identifier les années scolaires concernées pour chaque adresse (celles au 30/09)
), sco as (
    select 
        fiche
        , date_effect
        , date_effect_fin
        , ind_envoi_meq
        , case
			when cast(right(left(date_effect, 6), 2) as int) < 10 then cast(left(date_effect, 4) as int)
			else cast(left(date_effect, 4) as int) + 1
		end as annee_sco_deb
	    , case
			when cast(right(left(date_effect_fin, 6), 2) as int) < 10 then cast(left(date_effect_fin, 4) as int) - 1
			when cast(right(left(date_effect_fin, 6), 2) as int) >= 10 then cast(left(date_effect_fin, 4) as int)
			else {{ store.get_current_year() }}
		end as annee_sco_fin
        , code_post
    from dat

)

select 
    fiche
    , date_effect
    , date_effect_fin
    , annee_sco_deb
	, annee_sco_fin
    , code_post
from sco
where annee_sco_deb <= annee_sco_fin