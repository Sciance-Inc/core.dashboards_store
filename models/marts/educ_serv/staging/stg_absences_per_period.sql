{#
	This (sparse) table compute the number of absence periods per day and per students, for every student with at least one absence on a given day.
#}
select
    case
        when month(date_abs) <= 7 then year(date_abs) - 1 else year(date_abs)
    end as school_year,
    date_abs,
    fiche,
    id_eco,
    count(*) as n_periods_of_absence
from {{ ref("i_gpm_e_abs") }}
group by date_abs, fiche, id_eco
