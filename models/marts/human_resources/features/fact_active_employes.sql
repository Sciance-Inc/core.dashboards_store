{# 
    List all current ACTIVES employes at the time of the ETL run and provide some metadata such as worplace and employment category.

    For an employes to be active it must have been paid in the last two weeks and have a status set as active (from the seed).
 #}

-- Fetch the activity codes from the seed
WITH actives_etat_empl AS (
    SELECT DISTINCT etat_empl
    FROM {{ ref('etat_empl') }}
    WHERE etat_actif = 1 

-- Fetch the basee list of active employes, thoose with at least one payement in the last two weeks
), active_employees AS (
    SELECT 
        matr
    FROM {{ ref('i_pai_dos') }} AS src
    WHERE 
        etat_doss = 'A' AND
        date_dern_paie > DATEADD(WEEK , -2, getDate()) -- Make sure the activte employes have been paid in the last two weeks

-- Fetch their last known workplace, engagement status and workgroup
), active_employees_metadata AS (
    SELECT 
        src.matr,
        empl.etat,
        empl.lieu_trav,
        empl.corp_empl,
        empl.stat_eng,
        ROW_NUMBER() OVER (PARTITION BY src.matr ORDER BY empl.ref_empl DESC) AS seq_id
    FROM active_employees AS src
    -- Add the 
    LEFT JOIN {{ ref('i_pai_dos_empl') }} AS empl
    ON src.matr = empl.matr
    INNER JOIN actives_etat_empl AS act  -- Remove the employees with a Non-Active status
    ON empl.etat = act.etat_empl
)

SELECT 
    matr,
    etat,
    lieu_trav,
    corp_empl,
    stat_eng
FROM active_employees_metadata
WHERE seq_id = 1 -- Only keep the last known set of metadatas

