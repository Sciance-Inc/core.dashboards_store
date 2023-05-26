{{ config(alias='fact_effectif_css') }}


WITH spine AS (
    SELECT
        *
    FROM {{ ref('spine') }}
    WHERE annee BETWEEN {{ get_current_year() }} -4 AND {{ get_current_year() }} + 1
        AND seqid = 1
),

el AS (
    SELECT 
        spi.code_perm
        , spi.annee
        , spi.population
        , ele.sexe
        , spi.eco
        , eco.nom_eco
        , dan.classe
        , dan.ordre_ens
        , dan.plan_interv_ehdaa
        , dan.difficulte
        , CASE
            WHEN dan.ordre_ens = '3'  
                AND (dan.cycle_ref = '1' 
                AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7'))
                THEN 'Primaire 1'
            WHEN dan.ordre_ens = '3'  
                AND (dan.cycle_ref = '1'
                AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8'))
            THEN 'Primaire 2'
            WHEN dan.ordre_ens = '3'  
                AND (dan.cycle_ref = '2'
                AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7'))
                THEN 'Primaire 3'
            WHEN dan.ordre_ens = '3'  
                AND (dan.cycle_ref = '2' 
                AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8'))
                THEN 'Primaire 4'
            WHEN dan.ordre_ens = '3'  
                AND (dan.cycle_ref = '3' 
                AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7'))
                THEN 'Primaire 5'
            WHEN dan.ordre_ens = '3'  
                AND (dan.cycle_ref = '3' 
                AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8')) 
                THEN 'Primaire 6'
            WHEN dan.ordre_ens = '1' 
                THEN 'Maternelle 4'
            WHEN dan.ordre_ens = '2' 
                THEN 'Maternelle 5'        
            WHEN dan.ordre_ens = '4'  
                AND (dan.cycle_ref = '1'
                AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7'))
                THEN 'Secondaire 1'
            WHEN dan.ordre_ens = '4'  
                AND (dan.cycle_ref = '1'
                AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8'))
                THEN 'Secondaire 2'
            WHEN dan.ordre_ens = '4'  
                AND  ((dan.cycle_ref = '2'
                AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7'))
                OR dan.classe = '3')
                THEN 'Secondaire 3' 
            WHEN dan.ordre_ens = '4'  
                AND  ((dan.cycle_ref = '2'
                AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8'))
                OR dan.classe = '4')
                THEN 'Secondaire 4' 
            WHEN dan.ordre_ens = '4'  
                AND  ((dan.cycle_ref = '2'
                AND (dan.annee_cycle_ref = '3' OR dan.annee_cycle_ref = '9'))
                OR dan.classe in ('5','7','8'))
                THEN 'Secondaire 5' 
            ELSE '-'
        END AS cod_niveau_scolaire
        , dan.dist
        , dan.grp_rep
    FROM spine AS spi
    LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco
        ON spi.eco = eco.eco
    LEFT JOIN {{ ref('i_gpm_e_dan') }} AS dan
        ON spi.fiche = dan.fiche  AND eco.id_eco = dan.id_eco
    LEFT JOIN {{ ref('i_gpm_e_ele') }} AS ele
        ON spi.fiche = ele.fiche
    WHERE spi.annee = eco.annee
)

SELECT * FROM el