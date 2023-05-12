SELECT
    matr
    , nom_legal
    , date_nais
    , date_deb_serv
    , date_fin_serv 
    , date_eng
    , nom            
    , prnom
    , etat_doss
    , date_dern_paie  
FROM
    {{ var("database_paie") }}.dbo.pai_dos