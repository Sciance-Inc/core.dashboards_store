select
    annee,
    fiche,
    statut,
    niveauscolaire as niveau_scolaire,
    ecole,
    grouperepere as groupe_repere,
    age30sept as age_30_septembre,
    classification,
    rid
from {{ var("database_gpi") }}.edo.dossiers
