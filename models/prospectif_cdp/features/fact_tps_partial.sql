SELECT
    YEAR(date_entr) AS 'annee'
    , lieu_trav AS 'ecole'
    , COUNT(DISTINCT matr) AS 'total_employes'
<<<<<<< HEAD
FROM {{ adapt('interfaces', 'i_pai_dos') }}
=======
FROM {{ ref('i_pai_dos') }}
>>>>>>> develop
WHERE
    (stat_eng = 'E3')                             -- Statut d'emploi | E3 => Temps partiel
    and (YEAR(GETDATE()) - YEAR(date_entr) <= 10) -- 10 dernières années    
GROUP BY date_entr, lieu_trav