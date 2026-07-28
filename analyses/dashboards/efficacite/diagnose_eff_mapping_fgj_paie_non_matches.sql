-- Liste les écoles GPI sans lieu de travail Paie correspondant.
-- Ces lignes ne doivent pas être ajoutées à eff_mapping_fgj_paie avant résolution.
with
    gpi as (
        select
            eco as ecole_gpi,
            max(nom_eco) as nom_ecole_gpi,
            max(cat_eco) as categorie_ecole_gpi
        from {{ ref("i_gpm_t_eco") }}
        where eco is not null and eco <> '000'
        group by eco
    ),

    paie as (
        select lieu_trav
        from {{ ref("i_pai_tab_lieu_trav") }}
        where lieu_trav is not null
        group by lieu_trav
    )

select gpi.ecole_gpi, gpi.nom_ecole_gpi, gpi.categorie_ecole_gpi
from gpi
left join paie on paie.lieu_trav = gpi.ecole_gpi
where paie.lieu_trav is null
