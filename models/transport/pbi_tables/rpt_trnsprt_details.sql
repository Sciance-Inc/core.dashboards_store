
{# Extract the non-simulated parcours for the last 10 years #}
WITH parcours AS (
    SELECT 
        annee
        ,no_circ
        ,no_parc
        ,nom_parc
        ,per
    FROM {{ ref('i_geo_p_parc') }} 
    WHERE 
        simul = 0 AND
        annee >= YEAR(GETDATE()) - 10
         AND  ind_active = 1

{# Extract the non-simulated circuit for the last 10 years #}
), circuits AS (
    SELECT 
        nom_circ
        ,annee
        ,no_circ
    FROM {{ ref('i_geo_p_circ') }} 
    WHERE 
        simul = 0 AND
        annee >= YEAR(GETDATE()) - 10


{# Compute the most granular table, mapping parcours to their circuit #}
), circ_parc AS (
    SELECT 
        crc.annee
        ,crc.no_circ AS circuit_id
        ,crc.nom_circ AS circuit_name
        ,prc.no_parc AS parcours_id
        ,prc.nom_parc AS parcours_name
        ,prc.per AS parcours_periode
    FROM circuits AS crc
    LEFT JOIN parcours AS prc  -- circ_parc outer join if not every parcours can be attached to a circuit ; LEFT JOIN + tests If ALL parcours schould be attached to a circuit
    ON 
        crc.annee = prc.annee AND
        crc.no_circ = prc.no_circ


{# Propagate the circuit / parcours name changes #}
), last_names AS (
    SELECT 
        annee
        ,circuit_id
        ,LAST_VALUE(circuit_name) OVER (PARTITION BY circuit_id ORDER BY annee ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS circuit_name -- Get the most-up-to-date circuit name. If we want to allow the name to change between the year, then just add the name in the PARTITION BY clause
        ,parcours_id
        ,LAST_VALUE(parcours_name) OVER (PARTITION BY circuit_id, parcours_id ORDER BY annee ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS parcours_name -- Get the most-up-to-date circuit name. If we want to allow the name to change between the year, then just add the name in the PARTITION BY clause
        ,parcours_periode
    FROM circ_parc
), agg  AS (

{# Aggregate the table to  #}
SELECT 
    annee
    ,circuit_id
    ,MAX(circuit_name) AS circuit_name -- Dummy aggregation
    ,parcours_id
    ,MAX(parcours_name) AS parcours_name -- Dummy aggregation
    ,parcours_periode
FROM circ_parc
where parcours_id IS NOT NULL
GROUP BY 
    annee
    ,circuit_id
    ,parcours_id
    ,parcours_periode

)  

SELECT 
    annee
    ,circuit_id
    ,circuit_name
    ,parcours_id
    ,parcours_name
    ,CASE 
        WHEN parcours_periode = 1 THEN 'AM' 
        WHEN parcours_periode = 8 THEN 'PM' 
     END AS parcours_periode
     ,'Oui' AS actif 
    FROM agg
