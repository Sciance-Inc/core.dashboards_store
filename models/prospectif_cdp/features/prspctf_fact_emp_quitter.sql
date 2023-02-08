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
    FROM {{ ref('i_pai_dos') }}
    WHERE date_dern_jr_trav IS NOT NULL
    AND etat IN ('C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C08', 'C09', 'C10', 'C11', 'C12',    -- liste des etat_empl qui ont quitté et sont susceptibles d'être remplacer
                 'C13', 'C14', 'C15', 'C16', 'C17', 'C18', 'C19', 'C25', 'C27', 'C31', 'C32', 
                 'C66', 'C99')

)

SELECT
    concat(annee_budgetaire,annee_budgetaire+1) AS annee_budgetaire
    ,corp_empl
    ,COUNT(matr) as nb_empl_aremp
FROM src 
GROUP BY corp_empl, annee_budgetaire