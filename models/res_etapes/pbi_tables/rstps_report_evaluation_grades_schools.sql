{#
    Aggreagtes and compute the metric per year, schools and evaluation
#}

{{ config(
    alias='report_evaluation_grades_schools', 
    ) 
}}

WITH agg AS (
    SELECT 
        annee,
        ecole,
        friendly_name,
        COUNT(fiche) AS n_obs,
        CAST(SUM(cod_reussite) AS float) AS n_success,
        CAST(SUM(cod_reussite_threshold) AS float) AS n_success_threshold,
        AVG(resultat_numerique) AS resultat_avg,
        COALESCE(STDEV(resultat_numerique), 0) AS resultat_stdev
    FROM {{ ref('rstps_fact_evaluations_grades') }}
    GROUP BY
        annee,
        ecole,
        friendly_name

-- Add the statistis
), stats AS (
    SELECT 
        annee,
        ecole,
        friendly_name,
        {{ dbt_utils.surrogate_key(['annee', 'friendly_name']) }} as id_friendly_name,
        -- Compute the point-in-time statistics
        n_obs,
        resultat_avg,
        resultat_stdev,
        n_success,
        n_success / n_obs AS percent_of_success,
        n_success_threshold,
        n_success_threshold / n_obs AS percent_of_thresholded_success,
        -- Compute the running statistics
        CAST(running_resultat_avg AS FLOAT) / running_count AS running_resultat_avg_ma5,
        CAST(running_resultat_stdev AS FLOAT) / running_count AS running_resultat_stdev_ma5,
        running_success / running_count AS percent_of_success_ma5,
        running_thresholded_success / running_count AS percent_of_thresholded_success_ma5
    FROM (
        SELECT 
            annee,
            ecole,
            friendly_name,
            n_obs,
            n_success,
            n_success_threshold,
            resultat_avg,
            resultat_stdev,
            -- Add the RUNNING raw statistics
            SUM(resultat_avg * n_obs) OVER (PARTITION BY ecole, friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_resultat_avg,
            SUM(resultat_stdev * n_obs) OVER (PARTITION BY ecole, friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_resultat_stdev,
            SUM(n_success) OVER (PARTITION BY ecole, friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_success,
            SUM(n_success_threshold) OVER (PARTITION BY ecole, friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_thresholded_success,
            SUM(n_obs) OVER (PARTITION BY ecole, friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_count
        FROM agg
    ) AS src

), ecart AS(
    SELECT
    stats.*,
    (stats.percent_of_success)-(stcss.percent_of_success) AS ecart_percent_of_success,
    (stats.percent_of_thresholded_success)-(stcss.percent_of_thresholded_success) AS ecart_percent_of_thresholded_success,
    (stats.resultat_avg)-(stcss.resultat_avg) AS ecart_resultat_avg,
    (stats.resultat_stdev)-(stcss.resultat_stdev) AS ecart_resultat_stdev
FROM stats
LEFT JOIN {{ ref('rstps_report_evaluation_grades') }} AS stcss
ON stats.id_friendly_name = stcss.id_friendly_name 
)
-- Add the school friendly name
SELECT 
    -- Dimensions
    dim.annee,
    dim.ecole,
    dim.nom_ecole,
    ecart.friendly_name,
    ecart.id_friendly_name,
    -- Metrics
    ecart.n_obs,
    ecart.resultat_avg,
    ecart.resultat_stdev,
    ecart.percent_of_success,
    ecart.percent_of_thresholded_success,
    ecart.running_resultat_avg_ma5,
    ecart.running_resultat_stdev_ma5,
    ecart.percent_of_success_ma5,
    ecart.percent_of_thresholded_success_ma5,
    ecart.ecart_percent_of_success,
    ecart.ecart_percent_of_thresholded_success,
    ecart.ecart_resultat_avg,
    ecart.ecart_resultat_stdev
FROM ecart
LEFT JOIN {{ ref('i_gpm_edo_ecoles') }} AS dim
ON 
    ecart.ecole = dim.ecole AND
    ecart.annee = dim.annee




