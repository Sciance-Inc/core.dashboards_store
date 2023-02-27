

{{ config(alias='nb_ele_plus_de_66')}}

WITH filtr AS(
    SELECT
    annee
    , fiche
    , niveau_scolaire
    , res_fr
    , res_maths    
    , res_ang
    , res_sc
    , res_his
    FROM {{ ref('prspctf_fact_rslt_mat_select') }}
    WHERE  
        niveau_scolaire != '2e cycle - secondaire' 
        OR 
            (niveau_scolaire = '2e cycle - secondaire' 
            AND 
                (res_fr IS NOT NULL AND res_maths IS NOT NULL AND res_ang IS NOT NULL AND res_sc IS NOT NULL AND res_his IS NOT NULL
            ))
), src AS(
    SELECT
        annee
        , fiche
        , niveau_scolaire
        , res_fr
        , res_maths    
        , res_ang
        , res_sc
        , res_his
        ,CASE
            WHEN (niveau_scolaire = 'primaire' OR niveau_scolaire = '1er cycle - secondaire') 
                AND res_fr > 66 AND res_maths > 66 THEN 1
            WHEN niveau_scolaire = '2e cycle - secondaire' 
                AND res_fr > 66 AND res_maths > 66 AND res_ang > 66 AND res_sc > 66 AND res_his > 66 THEN 1
            ELSE 0 
            END AS ind_res_66
    FROM filtr
)
SELECT 
    annee
    ,SUM(ind_res_66) as sm
    ,COUNT(ind_res_66) as nb
    ,CAST(((CAST(SUM(ind_res_66) AS FLOAT)/CAST(COUNT(ind_res_66)AS FLOAT))*100) AS DECIMAL(5,2)) AS prop_res_66
FROM src
GROUP BY annee

