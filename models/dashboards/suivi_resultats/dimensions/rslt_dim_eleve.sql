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
with
    eleve as (
        select
            fiche,
            concat(nom, ', ', prenom, ' (', fiche, ')') as nom_prenom_fiche,
            row_number() over (partition by fiche order by rid desc) as seqid
        from {{ ref("i_eleves") }}

    ),
    ecole as (
        select
            annee,
            ecole,
            nom_ecole,
            row_number() over (partition by annee, ecole order by rid desc) as seqid
        from {{ ref("i_ecoles") }}

    -- Extract the of fiche, annee for which we have data
    ),
    dos as (
        select annee, fiche
        from {{ ref("i_dossiers") }}
        where
            statut = 'A'
            and annee
            between {{ store.get_current_year() }}
            - 4 and {{ store.get_current_year() }}
        group by annee, fiche

    -- Extract some static, student level metadata used for filtering
    ),
    meta as (
        select
            src.fiche,
            src.ecole,
            src.niveau_scolaire,
            src.age_30_septembre,
            src.classification,
            src.groupe_repere
        from
            (
                select
                    fiche,
                    ecole,
                    niveau_scolaire,
                    age_30_septembre,
                    classification,
                    groupe_repere,
                    row_number() over (
                        partition by fiche order by annee desc, rid asc
                    ) as seqid
                from {{ ref("i_dossiers") }}
            ) as src
        where src.seqid = 1
    )

select
    dos.annee,
    dos.fiche,
    ele.nom_prenom_fiche,
    eco.nom_ecole,
    meta.age_30_septembre,
    meta.classification,
    meta.groupe_repere
from dos as dos
inner join
    (select nom_prenom_fiche, fiche from eleve where seqid = 1) as ele
    on ele.fiche = dos.fiche
inner join meta as meta on meta.fiche = dos.fiche
inner join
    (select nom_ecole, ecole, annee from ecole where seqid = 1) as eco
    on eco.ecole = meta.ecole
    and eco.annee = dos.annee
