
{{ config(
    alias='ecoles', 
    ) 
}}

WITH ecoles AS (
    SELECT DISTINCT
        lieu_trav
        ,descr             AS lieu_trav_desc
    FROM  {{ ref('i_pai_tab_lieu_trav') }}
 
    WHERE
        -- Écoles seulement (les autres ce sont des services)
        eco_off IS NOT NULL             
    )

SELECT * FROM ecoles