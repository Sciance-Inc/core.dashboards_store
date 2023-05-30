{{ config(alias='nb_el_fgj') }}

WITH src AS (
	SELECT 
        spi.fiche
        , spi.population
        , eco.annee
        , eco.eco
    FROM {{ ref('spine') }} AS spi
    LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco
        ON spi.eco = eco.eco AND spi.annee = eco.annee
    WHERE spi.seqid = 1

{# Sum the number of students by population #}
), res AS (
	SELECT 
		population
        , annee
        , eco
		, COUNT(fiche) AS nb_eleves
	FROM src
	GROUP BY 
        annee,
        eco,
		population

{# Total sum #}
), tot AS (
	SELECT 
        annee
        , eco
		, SUM(nb_eleves) AS nb_eleves
	FROM res
	GROUP BY 
        annee,
        eco
)

SELECT 
	*
FROM res
UNION  
SELECT 
    'all' AS population
    , annee
    , eco
    , nb_eleves
FROM tot