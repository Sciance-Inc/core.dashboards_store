with base as (
select 
	fiche,
	eco.NOM_ECO,
	eco.id_eco,
	date_deb,
	date_depart
  FROM [192.168.207.153].[GPIPRIM].[dbo].[GPM_E_DAN] as dan
  JOIN [192.168.207.153].[GPIPRIM].[dbo].[GPM_T_ECO] as eco
  on dan.id_eco = eco.id_eco
  WHERE date_deb <= GETDATE() and fiche in (SELECT DISTINCT FICHE from tbe.dbo_educ_serv.fact_yearly_student)

), 
ingress as (
select 
	MAX(nom_eco) as nom_eco, --dummy agregation
	id_eco,
	date_deb as date_,
	count(distinct fiche) as n_students
from base
group by date_deb, id_eco 

), egress as (
select 
	MAX(nom_eco) as nom_eco, --dummy agregation
	id_eco,
	date_depart as date_,
	count(distinct fiche) as n_students
from base
where date_depart is not null
group by date_depart, id_eco 

), daily_students as (

select 
	coalesce(ing.id_eco, eg.id_eco) as id_eco,
	coalesce(ing.nom_eco, eg.nom_eco) as nom_eco,
	coalesce(ing.date_, eg.date_) as date_,
	coalesce(ing.n_students, 0) - coalesce(eg.n_students, 0) as delta
from ingress as ing
full outer join egress as eg
on ing.date_ = eg.date_ and ing.id_eco = eg.id_eco

)

select 
	id_eco, 
	nom_eco,
	date_,
	sum(delta) over (partition by id_eco order by date_ rows between unbounded preceding and current row) as n_students_daily
from daily_students
where nom_eco like '%assomp%'
order by nom_eco, date_







