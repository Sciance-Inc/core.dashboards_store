select
    annee,
    ecole,
    fiche,
    etat,
    codematiere as code_matiere,
    matieregroupe as groupe_matiere,
    resultat,
    resultatnumerique as resultat_numerique,
    codereussite as code_reussite,
    rid
from {{ var("database_gpi") }}.edo.matiereseleve
