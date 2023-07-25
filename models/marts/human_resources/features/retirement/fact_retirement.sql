{# 
    Extract the first retirement date for all of the employees.
#}

-- Extract all the valid retirement etat as well as the the corps_empl, lieu_trav and stat_eng at the time of retirement
WITH retirements AS (
    SELECT 
        matr,
        etat,
        corp_empl,
        lieu_trav,
        stat_eng,
        date_eff AS retirement_date,
        ROW_NUMBER() OVER (PARTITION BY matr ORDER BY date_eff, ref_empl DESC) AS seqId
FROM {{ ref('i_pai_dos_empl') }} AS empl
INNER JOIN (
    SELECT 
        etat_empl
    FROM {{ ref('etat_empl') }}
    WHERE empl_retr = 1 
) AS dim
ON empl.etat = dim.etat_empl


-- Remove any duplicates
), first_retirement AS (
    SELECT 
        matr,
        etat,
        corp_empl,
        lieu_trav,
        stat_eng,
        retirement_date
    FROM retirements
    WHERE seqId = 1


-- Compute the retirement age and add some metadata
), retirement_age AS (
    SELECT 
        frst.matr,
        frst.etat,
        frst.corp_empl,
        frst.lieu_trav,
        frst.stat_eng,
        frst.retirement_date,
        DATEDIFF(year, dos.date_nais, frst.retirement_date) AS retirement_age
    FROM first_retirement AS frst
    LEFT JOIN {{ ref('i_pai_dos') }} AS dos
    ON frst.matr = dos.matr
)

SELECT *
FROM retirement_age


