{#
Dashboards Store - Helping students, one dashboard at a time.
Copyright (C) 2023  Sciance Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
#}
{# identifier les usagers qui ont le droit d'accéder au TdB #}
with
    users as (
        select
            cleorganisationnelle as cle_organisationnelle,
            compteauthentification as compte_authentification,
            nom,
            prenom,
            ecoles,
            right(lieutravailprincipal, 4) as corps_emploi,
            left(lieutravailprincipal, 3) as ecole_principale,
            descriptioncorpsemploiprincipal as description_corps_emploi_principal
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
    cle_organisationnelle,
    compte_authentification,
    nom,
    prenom,
    ecoles,
    corps_emploi,
    ecole_principale,
    description_corps_emploi_principal,
    value as ecole
from users cross apply string_split(ecoles, ',')
