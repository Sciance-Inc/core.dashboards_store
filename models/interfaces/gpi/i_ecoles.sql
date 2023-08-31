select annee, ecole, nomecole as nom_ecole, rid
from {{ var("database_gpi") }}.edo.ecoles
