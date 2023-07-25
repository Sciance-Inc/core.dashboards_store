SELECT 
    etat_empl AS employment_status,
    CONCAT(descr, ' - (', etat_empl, ')') AS employment_status_name
FROM {{ ref('etat_empl') }}
