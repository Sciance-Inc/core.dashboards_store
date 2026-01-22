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
with
    spine as (
        select distinct lieu_jumele from {{ ref("eff_mapping_fgj_paie") }}

    -- gpi -> lieu_jumele
    ),
    gpi_to_lieu_jumele as (
        select lieu_jumele, max(ecole_gpi) as cod_eco  -- Arbitrary taking the last entry in lexicoggraphic order
        from {{ ref("eff_mapping_fgj_paie") }}
        group by lieu_jumele

    -- Select, for each lieu_jumele defining AT LEAST ONE school in GPI, a friendly
    -- name and a category
    ),
    partial_dim_eco as (
        select
            jml.lieu_jumele,
            concat('(', eco.cod_eco, ') - ', eco.nom_eco) as nom_lieu_jumele,
            descr.cf_descr as categorie_lieu_jumele
        from gpi_to_lieu_jumele as jml
        left join
            (
                select
                    eco as cod_eco,
                    cat_eco,
                    nom_eco,
                    row_number() over (partition by eco order by annee desc) as seq_id
                from {{ ref("i_gpm_t_eco") }}
            ) as eco
            on eco.seq_id = 1  -- Keep the most up to date attribute
            and jml.cod_eco = eco.cod_eco
        join
            {{ ref("i_wl_descr") }} as descr
            on descr.nom_table = 'CAT_ECO'
            and eco.cat_eco = descr.code

    -- paie -> lieu_jumele
    ),
    paie_to_lieu_jumele as (
        select lieu_jumele, max(lieu_trav) as lieu_trav  -- Arbitrary taking the last entry in lexicographic order
        from {{ ref("eff_mapping_fgj_paie") }}
        group by lieu_jumele

    ),
    partial_dim_lieu_travail as (
        select
            jml.lieu_jumele,
            concat('(', lieu.lieu_trav, ') - ', lieu.descr) as nom_lieu_jumele,
            type_lieu.descr as categorie_lieu_jumele
        from paie_to_lieu_jumele as jml
        left join
            {{ ref("i_pai_tab_lieu_trav") }} as lieu on jml.lieu_trav = lieu.lieu_trav
        left join
            {{ ref("i_pai_tab_type_lieu") }} as type_lieu
            on lieu.type_lieu = type_lieu.type_lieu

    )

select
    -- Entity
    spi.lieu_jumele,
    -- Attributes
    coalesce(
        cfg.nom_lieu_jumele, eco.nom_lieu_jumele, trv.nom_lieu_jumele, 'Inconnu'
    ) as nom_lieu_jumele,
    coalesce(
        cfg.categorie_lieu_jumele,
        eco.categorie_lieu_jumele,
        trv.categorie_lieu_jumele,
        'Non catégorisé'
    ) as categorie_lieu_jumele,
    cfg.is_school_comparable
from spine as spi
left join partial_dim_eco as eco on spi.lieu_jumele = eco.lieu_jumele
left join partial_dim_lieu_travail as trv on spi.lieu_jumele = trv.lieu_jumele
left join
    {{ ref("eff_reporting_configuration") }} as cfg on spi.lieu_jumele = cfg.lieu_jumele
