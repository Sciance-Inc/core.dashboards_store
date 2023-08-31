{{ config(alias="fact_tps_partial") }}

select
    year(date_entr) as 'annee',
    lieu_trav as 'ecole',
    count(distinct matr) as 'total_employes'
from {{ ref("i_pai_dos_empl") }}
where
    (stat_eng = 'E3')  -- Statut d'emploi | E3 => Temps partiel
    and (year(getdate()) - year(date_entr) <= 10)  -- 10 dernières années    
group by date_entr, lieu_trav
