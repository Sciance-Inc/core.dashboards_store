{#
    Trouver des élèves financès qui étaient financées deux fois par l''année
    Trouver des élèves fréquents qui étaient fréquents plus qu''une fois par l''année
#}
{{ config(alias="report_eleves_doublons_fin_fre") }}

with


    eleves as (
        select
            freq.fiche,
            freq.annee,
			school_friendly_name,
            date_deb_as_date,
            date_fin_as_date,
            type_freq
        from {{ ref("i_e_freq") }} as freq
        inner join
            {{ ref("dim_mapper_schools") }} as eco
            on eco.annee = freq.annee
            and eco.eco = freq.eco_cen
		and eco.id_eco in (select popl.id_eco from {{ ref("anml_stg_population") }} as popl
            group by popl.id_eco)
       
    
    ),
    -- Élèves Financés
    eleves_fin as (
        select
            fiche,
            annee,
            school_friendly_name,
            date_deb_as_date,
            date_fin_as_date,
            type_freq,
            row_number() over (
                partition by fiche, annee order by school_friendly_name
            ) as duplicat
        from eleves
        where type_freq = 'FIN'
    ),

    -- Élèves Financés Doublons
    eleves_fin_duplicats as (
        select fiche, annee, school_friendly_name, type_freq
        from eleves_fin
        where duplicat = 2  -- Prendre des eleves qui sont doublons 
    ),

    -- Élèves Fréquents
    eleves_fre as (
        select
            *,
            row_number() over (
                partition by fiche, annee order by date_deb_as_date
            ) as ordre
        from eleves
        where type_freq = 'FRE'
    ),
    -- Diviser Élèves Fréquents qui ont des conflits entre les dates
    eleves_fre_conflit as (
        select
            fiche,
            annee,
            school_friendly_name,
            date_deb_as_date,
            date_fin_as_date,
            ordre,
            type_freq,
            -- Prendre la valeur précédente de la date fin pour comparer et trouver
            -- des conflits

            -- DEBUG
            {#lag(date_fin_as_date) over (
                partition by fiche, annee order by date_deb_as_date
            ) as valeur_precdnt,#}

            -- Trouver le conflit entre les dates
            case
                when
                    lag(date_fin_as_date) over (
                        partition by fiche, annee order by date_deb_as_date
                    )
                    >= date_deb_as_date
                then 1
                else 0
            end as conflit_date
        from eleves_fre
    ),

    -- Eleves Fréquents Doublon
    eleves_fre_duplicats as (
        select fiche, annee, school_friendly_name, type_freq
        from eleves_fre_conflit
        where conflit_date = 1  -- Prendre des eleves qui ont un confit de date pour s'assurer que c'est un doublon
    ),
    -- Élèves Financés Doublons et Eleves Fréquents Doublons
    eleves_duplicat_tous as (
        select *
        from eleves_fre_duplicats
        union
        select *
        from eleves_fin_duplicats
    )

select
    fiche,
    annee,
    school_friendly_name,
    type_freq,
    {{ dbt_utils.generate_surrogate_key(["annee", "school_friendly_name"]) }}
    as filter_key
from eleves_duplicat_tous