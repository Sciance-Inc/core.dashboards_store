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
{{ config(alias="stg_spine") }}

-- Select the most up-to-date dossier for the last 5 years
with
    dossierseqid as (
        select
            annee,
            fiche,
            statut,
            niveau_scolaire,
            row_number() over (partition by fiche, annee order by rid desc) as seqid
        from {{ ref("i_dossiers") }}
        where
            statut = 'A'
            and annee
            between {{ store.get_current_year() }}
            - 4 and {{ store.get_current_year() }}

    -- Fetch all the students with at least a result during the considered timeframe
    ),
    students as (
        select distinct fiche
        from {{ ref("rslt_stg_resultats") }}
        where
            annee
            between {{ store.get_current_year() }}
            - 4 and {{ store.get_current_year() }}
            and resultat_numerique is not null
            or resultat is not null

    -- Keep the student currently enrolled in the CSS (first cycle of the secondary )
    ),
    enrolled as (
        select dos.fiche
        from dossierseqid as dos
        where
            seqid = 1
            and annee = {{ store.get_current_year() }}
            and niveau_scolaire in (select level from {{ ref("tracked_levels") }})
    )

-- Extract the history for all the students with a result in the last 5 years and
-- currently enrolled in the CSS
select dos.annee, dos.fiche, dos.niveau_scolaire
from dossierseqid as dos
inner join students as stu on stu.fiche = dos.fiche
inner join enrolled as enr on enr.fiche = dos.fiche
where dos.seqid = 1
