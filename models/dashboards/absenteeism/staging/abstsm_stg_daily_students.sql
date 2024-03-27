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

{{ config(alias="stg_daily_students") }}

{# Extract the 'grille' selection variables : default to the one used by VDC #}
{% set grille_section = var(
    "marts", {"educ_serv": {"absences": {"grille": ("1", "A")}}}
) %}
{% set grille_value = grille_section["educ_serv"]["absences"]["grille"] %}
{% set is_grille_value_default = grille_value == ("1", "A") %}

{% if execute %}
    {% if is_grille_value_default %}
        {{
            log(
                "Warning : dashboard absenteeism : the default 'grille' variable will be used to extract the absences. You might want to override it.",
                true,
            )
        }}
    {% endif %}
{% endif %}

with base as (
select 
	fiche,
	id_eco,
	date_debut,
	date_depart
from {{ ref("i_gpm_e_dan") }} 
WHERE date_debut <= GETDATE()

), 
-- Compute the number of new students every
ingress as (
	select
		id_eco,
		date_debut as date_,
		count(distinct fiche) as n_students
	from base
	group by date_debut, id_eco 

-- Compute the number of students leaving every day
), egress as (
select 
	id_eco,
	date_depart as date_,
	count(distinct fiche) as n_students
from base
where date_depart is not null
group by date_depart, id_eco 

-- Compute the daily delta between the new students, and the leavers.
), daily_students as (
select 
	coalesce(ing.id_eco, eg.id_eco) as id_eco,
	coalesce(ing.date_, eg.date_) as date_,
	coalesce(ing.n_students, 0) - coalesce(eg.n_students, 0) as delta
from ingress as ing
full outer join egress as eg
on ing.date_ = eg.date_ and ing.id_eco = eg.id_eco


-- Padd the delta on the calendar
), padded as (
select 
	coalesce(src.id_eco, cal.id_eco) as id_eco,
	coalesce(src.date_, cal.date_evenement) as date_,
	coalesce(src.delta, 0) as delta,
	case when jour_cycle is null then 0 else 1 end as is_school_day
from {{ ref("i_gpm_t_cal") }} as cal
left join daily_students as src 
on src.date_ = cal.date_evenement and src.id_eco = cal.id_eco
where 
	grille in {{ grille_value }} and 
	 cal.date_evenement <= GETDATE()

), daily as (
select 
	id_eco, 
	date_,
	is_school_day,
	sum(delta) over (partition by id_eco order by date_ rows between unbounded preceding and current row) as n_students_daily
from padded
)
-- Extract the etapes to be mapped back to table
, etapes (
	select id_eco, description, date_debut, date_fin
	from {{ ref("i_gpm_t_etape") }}
	WHERE etape in ('1','2','3') and date_deb is not null and date_fin is not null and nb_jours_classe IS NOT NULL
)











