select
    matr,
    nom_legal,
    date_nais,
    date_deb_serv,
    date_fin_serv,
    date_eng,
    date_entr,
    nom,
    prnom,
    sexe,
    etat_doss,
    date_dern_paie
from {{ var("database_paie") }}.dbo.pai_dos
