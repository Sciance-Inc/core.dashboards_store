SELECT 
    stat_eng AS engagement_status,
    CONCAT(descr, ' - (', stat_eng, ')') AS engagement_status_name
FROM {{ ref('stat_eng') }}
