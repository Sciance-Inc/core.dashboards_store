{#
    Shadow the fact table to extract the abseentees for the current year
#}
{{ config(alias="report_absences_listing") }}

select
    {{
        dbt_utils.generate_surrogate_key(
            ["src.eco", "src.school_year", "spi.population"]
        )
    }} as filter_key,
    spi.fiche,
    src.eco,
    bra.name as bracket_name,
    src.absence_start_date,
    src.absences_sequence_length
from {{ ref("fact_absences_sequence") }} as src
inner join
    {{ ref("spine") }} as spi
    on src.fiche = spi.fiche
    and src.eco = spi.eco
    and src.school_year = spi.annee
    and spi.seqid = 1
inner join
    {{ ref("repartition_brackets") }} as bra
    on src.absences_sequence_length >= bra.lower_bound
    and src.absences_sequence_length < bra.upper_bound
where
    src.school_year
    between {{ store.get_current_year() }} - 1 and {{ store.get_current_year() }}  -- Fetch the last two years
