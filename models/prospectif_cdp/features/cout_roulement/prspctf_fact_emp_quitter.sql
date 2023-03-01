{{ config(alias='fact_emp_quitter') }}


WITH src AS (
    SELECT
        matr
        , date_entr
        , lieu_trav
        , stat_eng
        , ref_empl
        , corp_empl
        , etat
        ,CASE 
            WHEN MONTH(date_dern_jr_trav) < 8 THEN YEAR(date_dern_jr_trav) - 1 
            ELSE YEAR(date_dern_jr_trav)
            END AS annee_budgetaire
    FROM {{ ref('i_pai_dos_empl') }}
    WHERE date_dern_jr_trav IS NOT NULL
    AND etat like 'C%'                                                                     -- liste des etat_empl qui ont quitté et sont susceptibles d'être remplacer

)

SELECT
    annee_budgetaire
    ,corp_empl
    ,COUNT(matr) as nb_empl_aremp
FROM src 
GROUP BY corp_empl, annee_budgetaire
