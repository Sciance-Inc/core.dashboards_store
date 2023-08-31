select
    fiche,
    annee,
    datedeb as date_deb,
    datefin as date_fin,
    statut,
    org,
    ecocen as eco_cen,
    bat,
    client,
    freq,
    prog,
    serviceenseign as service_enseign
from {{ var("database_jade") }}.dbo.e_freq
