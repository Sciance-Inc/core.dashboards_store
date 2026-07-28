-- Génère les lignes valides de la seed eff_mapping_fgj_paie.
-- Convention : le lieu jumelé est le code école GPI lorsque la liaison est exacte.
with
    gpi as (
        select eco as ecole_gpi
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

select
    paie.lieu_trav,
    gpi.ecole_gpi,
    gpi.ecole_gpi as lieu_jumele
from gpi
inner join paie on paie.lieu_trav = gpi.ecole_gpi
