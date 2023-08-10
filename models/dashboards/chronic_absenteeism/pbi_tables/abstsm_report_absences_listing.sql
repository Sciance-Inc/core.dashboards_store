{#
    Shadow the fact table to extract the abseentees for the current year
#}

{{ config(alias='report_absences_listing') }}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['src.eco', 'src.school_year', 'spi.population']) }} AS filter_key
    , spi.fiche
    , src.eco
    , bra.name AS bracket_name
    , src.absence_start_date
    , src.absences_sequence_length
FROM {{ ref('fact_absences_sequence') }} AS src
INNER JOIN {{ ref('spine') }} AS spi
ON 
    src.fiche = spi.fiche AND 
    src.eco = spi.eco AND 
    src.school_year = spi.annee AND
    spi.seqid = 1
INNER JOIN {{ ref('repartition_brackets') }} AS bra
ON 
    src.absences_sequence_length >= bra.lower_bound AND 
    src.absences_sequence_length < bra.upper_bound
WHERE src.school_year BETWEEN {{ store.get_current_year() }} - 1 AND {{ store.get_current_year() }}  -- Fetch the last two years
