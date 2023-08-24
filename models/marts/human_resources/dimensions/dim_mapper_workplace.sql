SELECT 
    lieu_trav AS workplace,
    CONCAT(descr, ' - (', lieu_trav, ')') AS workplace_name
FROM {{ ref('i_pai_tab_lieu_trav') }}
