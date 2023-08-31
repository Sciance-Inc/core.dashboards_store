{#
    Compute aggregated statistics over time at a school level
#}
{{ config(alias="report_absences_high_level_metrics") }}

-- Agregated absences at a student X school level X year level
with
    absences_aggregated as (
        select
            fiche,
            eco,
            school_year,
            count(*) as n_absences,
            avg(1.0 * absences_sequence_length) as avg_absences_sequence_length,
            max(absences_sequence_length) as max_absences_sequence_length
        from {{ ref("fact_absences_sequence") }}
        where school_year > {{ store.get_current_year() - 10 }}
        group by fiche, eco, school_year

    -- Left join on the population table to get the 0 absences case, AND the
    -- populations at the same time
    ),
    padded as (
        select
            spi.fiche,
            spi.eco,
            spi.annee as school_year,
            spi.population,
            abs.n_absences,  -- Keep the null as the the average schould not took into account the 0 absences
            abs.avg_absences_sequence_length,  -- Keep the null as the the average schould not took into account the 0 absences
            abs.max_absences_sequence_length  -- Keep the null as the the average schould not took into account the 0 absences
        from {{ ref("spine") }} as spi
        left join
            absences_aggregated as abs
            on spi.fiche = abs.fiche
            and spi.eco = abs.eco
            and spi.annee = abs.school_year
        where spi.seqid = 1

    -- Aggregated absences at a school X year X population
    ),
    aggregated as (
        select
            eco,
            school_year,
            population,
            avg(
                case when n_absences is not null then 1. else 0 end
            ) as proportion_of_absentees,
            -- For student with at least one absence
            avg(1. * n_absences) as avg_n_absences_for_absentees,
            avg(
                1. * avg_absences_sequence_length
            ) as avg_avg_absences_sequence_length_for_absentees,
            avg(
                1. * max_absences_sequence_length
            ) as avg_max_absences_sequence_length_for_absentees,
            count(*) as n_students
        from padded
        group by eco, school_year, population

    )

select
    {{ dbt_utils.generate_surrogate_key(["eco", "school_year", "population"]) }}
    as filter_key,
    school_year,
    proportion_of_absentees,
    avg_n_absences_for_absentees,
    avg_avg_absences_sequence_length_for_absentees,
    avg_max_absences_sequence_length_for_absentees,
    n_students
from aggregated
