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
{{ config(alias="fact_demission") }}

with  -- Étape 1
    step_one as (
        select
            hist.matr,  -- Matricule
            hist.date_eff,
            case
                when month(hist.date_eff) < 7  -- Année de chacune des références d'emplois
                then year(hist.date_eff) - 1
                else year(hist.date_eff)
            end as annee_budgetaire,
            case
                when
                    ((hist.etat = 'C08') or (hist.etat = 'C09') or (hist.etat = 'C17'))  -- Tous les employés ayant démissioné volontairement du 1 juillet au 30 juin de l'année            
                    and (
                        (month(hist.date_eff) > 06 and month(hist.date_eff) <= 12)
                        or (month(hist.date_eff) >= 01 and month(hist.date_eff) < 7)
                    )
                then 1
                else 0
            end as demission_volontaire
        from {{ ref("i_paie_hemp") }} as hist
        where hist.type = 'A'  -- Type de rénumération => Automatique

    ),
    step_two as (
        select
            matr,
            annee_budgetaire,
            date_eff,
            demission_volontaire,
            row_number() over (
                partition by matr, year(date_eff) order by date_eff desc
            ) as seqid
        from step_one
        where
            annee_budgetaire
            between {{ store.get_current_year() }}
            - 5 and {{ store.get_current_year() }}
    )

select *
from step_two
where seqid = 1
