select
    fiche,
    ecole_secteur,
    francisation,
    mesure_30810,
    ecole_virtuelle,
    particularite_sante,
    besoin_ressources,
    recommandations,
    date_maj
from {{ var("database_gpi") }}.dbo.gpm_e_ele_z_pers
