{{ config(alias="report_details") }}

{# Extract the non-simulated parcours for the last 10 years #}
with
    parcours as (
        select annee, no_circ, no_parc, nom_parc, per
        from {{ ref("i_geo_p_parc") }}
        where simul = 0 and annee >= year(getdate()) - 10 and ind_active = 1

    {# Extract the non-simulated circuit for the last 10 years #}
    ),
    circuits as (
        select nom_circ, annee, no_circ
        from {{ ref("i_geo_p_circ") }}
        where simul = 0 and annee >= year(getdate()) - 10

    {# Compute the most granular table, mapping parcours to their circuit #}
    ),
    circ_parc as (
        select
            crc.annee,
            crc.no_circ as circuit_id,
            crc.nom_circ as circuit_name,
            prc.no_parc as parcours_id,
            prc.nom_parc as parcours_name,
            prc.per as parcours_periode
        from circuits as crc
        left join
            parcours as prc  -- circ_parc outer join if not every parcours can be attached to a circuit ; LEFT JOIN + tests If ALL parcours schould be attached to a circuit
            on crc.annee = prc.annee
            and crc.no_circ = prc.no_circ

    {# Propagate the circuit / parcours name changes #}
    ),
    last_names as (
        select
            annee,
            circuit_id,
            last_value(circuit_name) over (
                partition by circuit_id
                order by annee
                rows between unbounded preceding and unbounded following
            ) as circuit_name,  -- Get the most-up-to-date circuit name. If we want to allow the name to change between the year, then just add the name in the PARTITION BY clause
            parcours_id,
            last_value(parcours_name) over (
                partition by circuit_id, parcours_id
                order by annee
                rows between unbounded preceding and unbounded following
            ) as parcours_name,  -- Get the most-up-to-date circuit name. If we want to allow the name to change between the year, then just add the name in the PARTITION BY clause
            parcours_periode
        from circ_parc
    ),
    agg as (

        {# Aggregate the table to  #}
        select
            annee,
            circuit_id,
            max(circuit_name) as circuit_name,  -- Dummy aggregation
            parcours_id,
            max(parcours_name) as parcours_name,  -- Dummy aggregation
            parcours_periode
        from circ_parc
        where parcours_id is not null
        group by annee, circuit_id, parcours_id, parcours_periode

    )

select
    annee,
    sec.circuit_id,
    circuit_name,
    name_sector,
    abbr_sector,
    parcours_id,
    parcours_name,
    case
        when parcours_periode = 1
        then 'AM'
        when parcours_periode = 8
        then 'PM'
        when parcours_periode not like '1' and parcours_periode not like '8'
        then 'Midi'
    end as parcours_periode,
    'Oui' as actif
from agg as src
left join
    {{ source_or_ref("transport", "stg_sectors") }} as sec
    on src.circuit_id = sec.circuit_id
