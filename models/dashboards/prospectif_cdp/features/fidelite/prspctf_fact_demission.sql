{{ config(alias='fact_demission') }}

WITH -- Étape 1
step_one AS (
    SELECT hist.matr -- Matricule
    , hist.date_eff
    , CASE WHEN MONTH(hist.date_eff) < 7 -- Année de chacune des références d'emplois
            THEN YEAR(hist.date_eff) - 1
            ELSE YEAR(hist.date_eff)
    END AS annee_budgetaire
    , CASE WHEN ((hist.etat = 'C08') OR (hist.etat = 'C09') OR (hist.etat = 'C17')) -- Tous les employés ayant démissioné volontairement du 1 juillet au 30 juin de l'année            
    AND ((MONTH(hist.date_eff) > 06 AND MONTH(hist.date_eff) <= 12)
        OR (MONTH(hist.date_eff) >= 01 AND MONTH(hist.date_eff) < 7)) THEN 1 ELSE 0 
    END AS demission_volontaire
    FROM {{ ref('i_paie_hemp') }} AS hist
    WHERE hist.type = 'A'  -- Type de rénumération => Automatique

), step_two AS (
    SELECT 
        matr,
		annee_budgetaire,
		date_eff,
        demission_volontaire,
        ROW_NUMBER() OVER (PARTITION BY matr, YEAR(date_eff) ORDER BY date_eff DESC) AS seqid
    FROM step_one
    WHERE annee_budgetaire BETWEEN {{  store.get_current_year() }} - 5 AND {{  store.get_current_year() }}
)

SELECT * 
FROM step_two 
WHERE seqid = 1