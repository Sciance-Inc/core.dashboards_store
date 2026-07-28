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
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["id_eco", "fiche"]
            ),
        ]
    )
}}

with
    base as (
        select
            eco.id_eco,
            dan.fiche,
            model_etape_client.modele_etape,
            org_year.date_deb as org_date_deb,
            org_year.date_fin as org_date_fin
        from {{ ref("i_gpm_t_org_annee") }} as org_year
        join
            {{ ref("i_gpm_t_eco") }} as eco
            on org_year.org = eco.org
            and org_year.annee = eco.annee
            and eco.indic_eco_bidon is null
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
    )

select
    base.id_eco,
    base.fiche,
    etapes.modele_etape,
    etapes.seq_etape,
    etapes.etape,
    etapes.etape_description,
    etapes.nb_jours_classe,
    etapes.date_deb as date_debut,
    etapes.date_fin,
    etapes.is_based_on_etape_model
from
    base
    cross apply
    (
        select
            base.modele_etape,
            mee.seq_etape,
            mee.etape,
            mee.descr as etape_description,
            mee.nb_jours_classe,
            mee.date_deb,
            mee.date_fin,
            1 as is_based_on_etape_model
        from {{ ref("i_gpm_t_modele_etape") }} as me
        inner join
            {{ ref("i_gpm_t_modele_etape_etapes") }} as mee
            on mee.id_eco = me.id_eco
            and mee.modele_etape = me.modele_etape
        where
            base.modele_etape is not null
            and me.id_eco = base.id_eco
            and me.modele_etape = base.modele_etape
            and mee.date_deb >= base.org_date_deb
            and mee.date_fin <= base.org_date_fin

        union all

        select
            base.modele_etape,
            etape.seq_etape,
            etape.etape,
            etape.descr as etape_description,
            etape.nb_jours_classe,
            etape.date_deb,
            etape.date_fin,
            0 as is_based_on_etape_model
        from {{ ref("i_gpm_t_etape") }} as etape
        where
            base.modele_etape is null
            and etape.id_eco = base.id_eco
            and etape.date_deb >= base.org_date_deb
            and etape.date_fin <= base.org_date_fin
    ) as etapes
