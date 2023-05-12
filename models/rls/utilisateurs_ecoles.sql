{# identifier les usagers qui ont le droit d'accéder au TdB #}
WITH users AS (
    SELECT
        CleOrganisationnelle
        , CompteAuthentification
        , Nom
        , Prenom
        , Ecoles
        , RIGHT(LieuTravailPrincipal, 4) AS CorpsEmploi
        , LEFT(LieuTravailPrincipal, 3) AS Ecole_principale
        , DescriptionCorpsEmploiPrincipal
    FROM {{  var("database_paie") }}.GI.Identite
    
    WHERE RIGHT(LieuTravailPrincipal, 4) IN (
            '1155','1255',-- directions / directions adj secondaire
            '1150','1250',-- directions / directions adj primaire
             -- enseignant secondaire
            '3108',-- Form. gén. angl. sec.
            '3109',-- Form. gén. éd. phys. sec.
            '3110',-- Form. gén. musique sec.
            '3111',-- Frm. gén. arts plas. sec.
            '3112',-- Form. gén. franç. sec.
            '3113',-- Form. gén. math. sc. sec.
            '3114',-- Éthique et cult. rel
            '3117',-- Frm. gn. géo.hist. éduc.c
                -- enseignant ele en dif.        
            '3101',-- Ens. auprès élè. en diff.
            '3120',-- Ens. francais accueil
                -- enseignant primaire
            '3140',-- Ens ortho. prim. (art.42)
            '3103'-- enseignant primaire
            )
)
{# Mettre au format usager/ecole #}
SELECT
    CleOrganisationnelle
    , CompteAuthentification
    , Nom
    , Prenom
    , Ecoles
    , CorpsEmploi
    , Ecole_principale
    , DescriptionCorpsEmploiPrincipal
    , value AS Ecole
FROM users
CROSS APPLY STRING_SPLIT(Ecoles, ',')  