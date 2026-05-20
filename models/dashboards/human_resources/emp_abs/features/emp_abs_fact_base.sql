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
{{ config(alias="fact_emp_abs") }}


with
    absences_employe as (
        select
            abs.matricule,
            abs.date_abs,
            case
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    < 25
                then '24 ans et moins'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 25 and 34
                then '25 à 34 ans'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 35 and 44
                then '35 à 44 ans'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 45 and 54
                then '45 à 54 ans'
                when
                    datediff(
                        year,
                        emp.birth_date,
                        cast(left(abs.annee, 4) + '-07-01' as date)
                    )
                    between 55 and 64
                then '55 à 64 ans'
                else '65 ans et plus'
            end as tranche_age

        from {{ ref("fact_absence") }} as abs
        inner join {{ ref("dim_employees") }} as emp on abs.matricule = emp.matr
    )

select *
from absences_employe
