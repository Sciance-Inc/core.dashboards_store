{#
Dashboards Store - Helping students, one dashboard at a time.
Copyright (C) 2023  Sciance Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
#}
{# Extrat the starting and ending dates of etapes #}
{{
    config(
        post_hook=[
            store.create_clustered_index("{{ this }}", ["id_eco", "fiche"]),
        ]
    )
}}

-- Treat the school with a defined 'model_etape'
with
    with_model as (
        select
            -- Meta fields to map a student against the etape.
            eco.id_eco,
            dan.fiche,
            -- Etape's attributes
            model_etape_client.modele_etape,
            mee1.seq_etape,
            mee1.etape,
            mee1.descr as etape_description,
            mee1.nb_jours_classe,
            mee1.date_deb,
            mee1.date_fin,
            -- Meta
            1 as is_based_on_etape_model
        from {{ ref("i_gpm_t_org_annee") }} as org_year
        join
            {{ ref("i_gpm_t_eco") }} as eco
            on org_year.org = eco.org
            and org_year.annee = eco.annee
            and eco.indic_eco_bidon is null
        join {{ ref("i_gpm_e_dan") }} as dan on eco.id_eco = dan.id_eco
        -- Fetch the fields to build the students matching composite key for. 
        join
            {{ ref("i_gpm_t_modele_etape_client") }} as model_etape_client
            on model_etape_client.id_eco = eco.id_eco
            and model_etape_client.ordre_ens = dan.ordre_ens
            and model_etape_client.classe = dan.classe
            and (
                coalesce(model_etape_client.dist, '') = coalesce(dan.dist, '')
                or model_etape_client.dist is null
            )
            and (
                coalesce(model_etape_client.grp_rep, '') = coalesce(dan.grp_rep, '')
                or model_etape_client.grp_rep is null
            )
            and (
                coalesce(model_etape_client.class, '') = coalesce(dan.class, '')
                or model_etape_client.class is null
            )
        -- Filter down to remove potential inactives etapes
        join
            {{ ref("i_gpm_t_modele_etape") }} as me
            on me.id_eco = model_etape_client.id_eco
            and me.modele_etape = model_etape_client.modele_etape
        -- Extract etape's attributes
        join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as mee1
            on mee1.id_eco = eco.id_eco
            and mee1.modele_etape = model_etape_client.modele_etape
            and (
                mee1.date_deb >= org_year.date_deb
                and mee1.date_fin <= org_year.date_fin
            )

    -- Handle cases were no 'model_etape' is defined
    ),
    without_model as (
        select
            -- Meta fields to map a student against the etape.
            eco.id_eco,
            dan.fiche,
            -- Etape's attributes
            model_etape_client.modele_etape,  -- always null. 
            etape.seq_etape,
            etape.etape,
            etape.descr as etape_description,
            etape.nb_jours_classe,
            etape.date_deb,
            etape.date_fin,
            0 as is_based_on_etape_model
        from {{ ref("i_gpm_t_org_annee") }} as org_year
        join
            {{ ref("i_gpm_t_eco") }} as eco
            on org_year.org = eco.org
            and org_year.annee = eco.annee
            and eco.indic_eco_bidon is null
        join
            {{ ref("i_gpm_t_etape") }} as etape
            on etape.id_eco = eco.id_eco
            and (
                etape.date_deb >= org_year.date_deb
                and etape.date_fin <= org_year.date_fin
            )
        join {{ ref("i_gpm_e_dan") }} as dan on eco.id_eco = dan.id_eco
        left join
            {{ ref("i_gpm_t_modele_etape_client") }} as model_etape_client
            on model_etape_client.id_eco = eco.id_eco
            and model_etape_client.ordre_ens = dan.ordre_ens
            and model_etape_client.classe = dan.classe
            and (
                coalesce(model_etape_client.dist, '') = coalesce(dan.dist, '')
                or model_etape_client.dist is null
            )
            and (
                coalesce(model_etape_client.grp_rep, '') = coalesce(dan.grp_rep, '')
                or model_etape_client.grp_rep is null
            )
            and (
                coalesce(model_etape_client.class, '') = coalesce(dan.class, '')
                or model_etape_client.class is null
            )
        where model_etape_client.modele_etape is null  -- Make sure we are only fetching the ones without a model

    -- Unionized the two tables
    ),
    unionized as (

        select *
        from with_model
        union all
        select *
        from without_model
    )

select
    id_eco,
    fiche,
    modele_etape,
    seq_etape,
    etape,
    etape_description,
    nb_jours_classe,
    date_deb as date_debut,
    date_fin,
    is_based_on_etape_model
from unionized
