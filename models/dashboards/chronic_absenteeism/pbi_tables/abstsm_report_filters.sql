{#
    Gather all the filters into one table to allow for between-pages corss filtering.
#}
{{ config(alias="report_absences_filters") }}

-- Select all the schools / year  we have data for with respect to a 10 years time
-- frame.
with
    eco as (
        select eco, annee as school_year, school_friendly_name
        from {{ ref("dim_mapper_schools") }}
        where
            annee
            between {{ store.get_current_year() - 10 }}
            and {{ store.get_current_year() }}

    -- Select all the distinct population we have data for
    ),
    popu as (select distinct population from {{ ref("spine") }})

-- Create the composite filter key
select
    eco.school_friendly_name,
    convert(date, concat(eco.school_year, '-09-1'), 102) as school_year,
    popu.population,
    {{
        dbt_utils.generate_surrogate_key(
            ["eco.eco", "eco.school_year", "popu.population"]
        )
    }} as filter_key
from eco as eco
cross join popu as popu
where
    eco.eco is not null
    and eco.school_friendly_name is not null
    and popu.population is not null
    and eco.school_year is not null
