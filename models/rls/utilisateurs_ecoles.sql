{# identifier les usagers qui ont le droit d'accéder au TdB #}
with
    users as (
        select
            cleorganisationnelle,
            compteauthentification,
            nom,
            prenom,
            ecoles,
            right(lieutravailprincipal, 4) as corpsemploi,
            left(lieutravailprincipal, 3) as ecole_principale,
            descriptioncorpsemploiprincipal
        from {{ var("database_paie") }}.gi.identite

        where
            right(lieutravailprincipal, 4) in (
                '1155',
                '1255',  -- directions / directions adj secondaire
                '1150',
                '1250',  -- directions / directions adj primaire
                -- enseignant secondaire
                '3108',  -- Form. gén. angl. sec.
                '3109',  -- Form. gén. éd. phys. sec.
                '3110',  -- Form. gén. musique sec.
                '3111',  -- Frm. gén. arts plas. sec.
                '3112',  -- Form. gén. franç. sec.
                '3113',  -- Form. gén. math. sc. sec.
                '3114',  -- Éthique et cult. rel
                '3117',  -- Frm. gn. géo.hist. éduc.c
                -- enseignant ele en dif.        
                '3101',  -- Ens. auprès élè. en diff.
                '3120',  -- Ens. francais accueil
                -- enseignant primaire
                '3140',  -- Ens ortho. prim. (art.42)
                '3103'  -- enseignant primaire
            )
    )
{# Mettre au format usager/ecole #}
select
    cleorganisationnelle,
    compteauthentification,
    nom,
    prenom,
    ecoles,
    corpsemploi,
    ecole_principale,
    descriptioncorpsemploiprincipal,
    value as ecole
from users cross apply string_split(ecoles, ',')
