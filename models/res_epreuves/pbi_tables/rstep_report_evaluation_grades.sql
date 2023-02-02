{#
    Aggreagtes and compute the metric per year, schools and evaluation
#}

{{ config(
    alias='report_evaluation_grades', 
    ) 
}}

WITH agg AS (
    SELECT 
        annee,
        friendly_name,
        COUNT(fiche) AS n_obs,
        CAST(SUM(cod_reussite) AS float) AS n_success,
        CAST(SUM(cod_reussite_threshold) AS float) AS n_success_threshold,
        AVG(resultat_numerique) AS resultat_avg,
        COALESCE(STDEV(resultat_numerique), 0) AS resultat_stdev
    FROM {{ ref('rstep_fact_evaluations_grades') }}
    GROUP BY
        annee,
        friendly_name

-- Add the statistis
), stats AS (
    SELECT 
        annee,
        friendly_name,
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
            friendly_name,
            n_obs,
            n_success,
            n_success_threshold,
            resultat_avg,
            resultat_stdev,
            -- Add the RUNNING raw statistics
            SUM(resultat_avg * n_obs) OVER (PARTITION BY friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_resultat_avg,
            SUM(resultat_stdev * n_obs) OVER (PARTITION BY friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_resultat_stdev,
            SUM(n_success) OVER (PARTITION BY friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_success,
            SUM(n_success_threshold) OVER (PARTITION BY friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_thresholded_success,
            SUM(n_obs) OVER (PARTITION BY friendly_name ORDER BY annee ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS running_count
        FROM agg
    ) AS src

)

-- Add the school friendly name
SELECT 
    -- Dimensions
    {{ dbt_utils.generate_surrogate_key(['stats.annee', 'stats.friendly_name']) }} as id_friendly_name,
    stats.annee,
    stats.friendly_name,
    -- Metrics
    stats.n_obs,
    stats.resultat_avg,
    stats.resultat_stdev,
    stats.percent_of_success,
    stats.percent_of_thresholded_success,
    stats.running_resultat_avg_ma5,
    stats.running_resultat_stdev_ma5,
    stats.percent_of_success_ma5,
    stats.percent_of_thresholded_success_ma5
FROM stats