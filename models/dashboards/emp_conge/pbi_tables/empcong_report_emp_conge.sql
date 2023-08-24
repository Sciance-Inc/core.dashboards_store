{{ config(
    alias='report_emp_conge', 
    ) 
}}

WITH agg AS (
    SELECT
        annee
        , lieu_trav
        , lieu_trav_descr
        , corps_demploi_description
        , etat_description 
        , cong_lt
        , COUNT(matricule) AS n_matr
    FROM  {{ ref('empcong_fact_emp_conge') }}
    WHERE annee BETWEEN {{  store.get_current_year() }} - 10 AND {{  store.get_current_year() }}
    GROUP BY 
        annee
        , lieu_trav
        , lieu_trav_descr
        , corps_demploi_description
        , etat_description
        , cong_lt
)

SELECT 
    annee
    , CONCAT(lieu_trav, ' | ' , lieu_trav_descr) AS lieu_trav
    , corps_demploi_description
    , etat_description
    , n_matr
    , CASE
        WHEN cong_lt = 1 THEN 'Oui'
        ELSE 'Non'
    END AS cong_lt
FROM agg