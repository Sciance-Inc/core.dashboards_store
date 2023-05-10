{{ config(alias='fact_effectif_css') }}

WITH spine AS (
    SELECT
        *
    FROM {{ ref('base_spine') }}
    WHERE annee BETWEEN {{ get_current_year() }} -4 AND {{ get_current_year() }} + 1
        AND seqid = 1
),

el AS (
    SELECT 
        spi.fiche
        , spi.id_eco
        , spi.annee
        , spi.population
        , eco.eco
        , eco.nom_eco
        , dan.classe
        , dan.ordre_ens
        , dan.plan_interv_ehdaa
        , dan.difficulte
        , CASE
            WHEN dan.ordre_ens = '1' THEN 'PRES4ANS'
            WHEN dan.ordre_ens = '2' THEN 'PRES5ANS'
            WHEN (dan.cycle_ref = '1' AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7')) THEN 'PRI1'
            WHEN (dan.cycle_ref = '1' AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8')) THEN 'PRI2'
            WHEN (dan.cycle_ref = '2' AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7')) THEN 'PRI3'
            WHEN (dan.cycle_ref = '2' AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8')) THEN 'PRI4'
            WHEN (dan.cycle_ref = '3' AND (dan.annee_cycle_ref = '1' OR dan.annee_cycle_ref = '7')) THEN 'PRI5'
            WHEN (dan.cycle_ref = '3' AND (dan.annee_cycle_ref = '2' OR dan.annee_cycle_ref = '8')) THEN 'PRI6'
            WHEN dan.classe = '1' THEN 'SEC1'
            WHEN dan.classe = '2' THEN 'SEC2'
            WHEN dan.classe = '3' THEN 'SEC3'
            WHEN dan.classe = '4' THEN 'SEC4'
            WHEN (dan.classe = '5' OR dan.classe = '7' OR dan.classe = '8') THEN 'SEC5'
            ELSE 'ANNEE INCONNU'
        END AS el_cod_niveau
        , dan.dist
        , dan.grp_rep
    FROM spine AS spi
        LEFT JOIN {{ ref('i_gpm_e_dan') }} AS dan ON spi.fiche = dan.fiche AND spi.id_eco = dan.id_eco
        LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco ON spi.id_eco = eco.id_eco
)

SELECT * FROM el