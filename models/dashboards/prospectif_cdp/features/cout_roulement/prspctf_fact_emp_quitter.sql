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
{{ config(alias="fact_emp_quitter") }}


with
    src as (
        select
            his.matr,
            his.date_eff,
            his.corp_empl,
            his.etat,
            case
                when month(his.date_eff) < 7
                then year(his.date_eff) - 1
                else year(his.date_eff)
            end as annee_budgetaire
        from {{ ref("i_paie_hemp") }} as his
        left join {{ ref("stat_eng") }} as se on (se.stat_eng = his.stat_eng)
        where
            se.is_reg = 1  -- on garde que les employées permanent
            and his.type = 'A'  -- on garde que les employées avec paiement auto    

    -- on detecte les employés avec un code etat débute par un C% 
    ),
    bool as (
        select *, case when etat not like 'C%' then 0 else 1 end as quit from src

    -- - on verifie si son code etat à changé
    ),
    lagged as (
        select
            *, lag(quit, 1, 0) over (partition by matr order by date_eff) as quitlagged
        from bool
    ),
    retour as (
        select
            *,
            case when quitlagged != quit and quitlagged = 1 then 1 else 0 end as retrn
        from lagged
    ),
    index_ as (
        select
            *,
            sum(retrn) over (
                partition by matr
                order by date_eff
                rows between unbounded preceding and current row
            ) as partitionid
        from retour
    ),
    step as (
        select
            matr,
            date_eff,
            corp_empl,
            etat,
            annee_budgetaire,
            partitionid,
            row_number() over (
                partition by matr order by partitionid desc, date_eff desc
            ) as seqid
        from index_
    )
select annee_budgetaire, corp_empl, count(matr) as nb_empl_aremp
from step
where etat like 'C%' and seqid = 1
group by corp_empl, annee_budgetaire
