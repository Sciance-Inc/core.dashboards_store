{{ config(alias='fact_emp_quitter') }}


WITH src AS (
    SELECT
        his.matr
        , his.date_eff
        , his.corp_empl
		, his.etat
        , CASE 
            WHEN MONTH(his.date_eff) < 7 THEN YEAR(his.date_eff) - 1 
            ELSE YEAR(his.date_eff)
            END AS annee_budgetaire
    FROM {{ ref('i_paie_hemp') }} AS his
    LEFT JOIN {{ adapt('employees_status','cstmrs_stat_eng') }} AS se 
        ON (se.stat_eng = his.stat_eng) 
    WHERE se.stat_st = 1                                            --on garde que les employées permanent
	    AND his.type = 'A'                                           --on garde que les employées avec paiement auto    

-- on detecte les employés avec un code etat débute par un C% 

),bool AS (
    SELECT 
        *,
        CASE WHEN etat NOT LIKE 'C%' THEN 0 ELSE 1 END AS quit
    FROM src


--- on verifie si son code etat à changé
    
),lagged AS (
    SELECT
        *,
        LAG(quit, 1, 0) OVER (PARTITION BY matr ORDER BY date_eff) AS quitlagged
    FROM bool
),retour AS (
    SELECT 
        *,
        CASE WHEN quitlagged != quit AND quitlagged = 1 THEN 1 ELSE 0 END AS retrn
    FROM lagged
),index_ AS (
    SELECT 
        *,
        SUM(retrn) OVER (PARTITION BY matr ORDER BY date_eff ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS partitionId
    FROM retour
),step AS (
    SELECT 	matr
        ,date_eff
        ,corp_empl
        ,etat
        ,annee_budgetaire
        ,partitionId
        ,ROW_NUMBER() OVER (PARTITION BY matr ORDER BY partitionId DESC, date_eff DESC) AS seqid
	FROM index_ 
)
SELECT
    annee_budgetaire
    ,corp_empl
    ,COUNT(matr) AS nb_empl_aremp
FROM step 
WHERE etat LIKE 'C%' AND seqid = 1
GROUP BY corp_empl, annee_budgetaire


    
    
