select
    fiche,
    ecole,
    annee,
    codematiere as code_matiere,
    etape,
    nocompetence as no_competence,
    resultat,
    resultatnumerique as resultat_numerique,
    codereussite as code_reussite
from {{ var("database_gpi") }}.edo.resultatscompetenceetape
