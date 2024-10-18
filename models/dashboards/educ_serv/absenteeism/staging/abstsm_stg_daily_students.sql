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
{#
    Compute an unpadded version of the daily number of students.
    The daily number of students is computed using the DAN table (namely date_debut and date_depart), by integrating the delta between the new students and the leavers every day (ie, the Bathtub algorithm).
    The daily number of studends is computed at a school, grille and etape level. 
    Since their is no functor mapping the (grille, id_eco) tuple to an etape, the DAN is first transformed to have one row per student and etape.
    By repeating the student for every etape it belongs to, the set of (etape, grille, id_eco) tuples are non-overlapping and independent. They can be treated in complete isolation.
    The bathtub algorithm is applied to every element of the set of (etape, grille, id_eco) tuples independently.

    The integration of delta is of O(N) complexity.
    The alternative would be to use a fan-out then aggregate pattern, through a cross join on the seq_int_0_to_1000 table. This would have had something like a O(360*N) complexity. 

#}
{{
    config(
        alias="stg_daily_students",
        post_hook=[
            core_dashboards_store.create_clustered_index(
                "{{ this }}", ["id_eco", "grille", "date_evenement"]
            ),
            core_dashboards_store.create_nonclustered_index(
                "{{ this }}", ["date_evenement"]
            ),
        ],
    )
}}

-- Extract the DAN
with
    base as (
        select
            dan.fiche,
            dan.id_eco,
            dan.date_debut,
            coalesce(dan.date_depart, oa.date_fin) as date_depart,  -- Impute the date_depart with the end of the year if it is missing. 
            coalesce(dan.grille, 'unknown') as grille,
            -- Fetch the year start / end, to latter padd the missing etape
            oa.date_deb as annee_date_debut,
            oa.date_fin as annee_date_fin
        from {{ ref("i_gpm_e_dan") }} as dan
        join {{ ref("i_gpm_t_eco") }} as eco on dan.id_eco = eco.id_eco
        join {{ ref("i_gpm_t_org_annee") }} as oa on eco.annee = oa.annee
        where dan.date_debut <= getdate()

    -- Extract a subset of etapes we want to compute the absences for.
    ),
    etapes as (
        select id_eco, fiche, seq_etape, etape, etape_description, date_debut, date_fin
        from {{ ref("stg_fact_fiche_etapes") }}
        where etape in ('1', '2', '3')  -- If you want to consider ALL etapes, remove the the where clause and add a CASE WHEN etape in ('1', '2', '3') then etape else 0 end

    -- Expanse the DAN to get one row per student and etape (The bathtub algorithm
    -- needs the cells to be disjunctive. But, because of the grid depends on some low
    -- level students attributes, grille and etapes are not disjunctives. The
    -- expansion solve the backfilling issue.)
    ),
    expansed as (
        select
            base.fiche,
            base.id_eco,
            base.date_debut,
            base.date_depart,
            base.grille,
            coalesce(etp.etape, 0) as etape,
            -- If no etape can be matched against the student, use the year's start
            -- and end date. Dates are required to later down filter out-of-etape days
            coalesce(etp.date_debut, base.annee_date_debut) as etape_date_debut,
            coalesce(etp.date_fin, base.annee_date_fin) as etape_date_fin
        from base
        left join etapes as etp on base.fiche = etp.fiche and base.id_eco = etp.id_eco
        -- Remove the students that are not in the etape's date range
        where
            base.date_debut between etp.date_debut and etp.date_fin
            or base.date_depart between etp.date_debut and etp.date_fin
            or (base.date_debut <= etp.date_debut and base.date_depart >= etp.date_fin)

    -- Compute the number of new students every day
    ),
    ingress as (
        select
            expa.id_eco,
            expa.grille,
            expa.date_debut as date_evenement,
            expa.etape as etape,
            min(expa.etape_date_debut) as etape_date_debut,
            max(expa.etape_date_fin) as etape_date_fin,
            count(distinct expa.fiche) as n_students
        from expansed as expa
        group by expa.date_debut, expa.id_eco, expa.grille, expa.etape

    -- Compute the number of students leaving every day
    ),
    egress as (
        select
            expa.id_eco,
            expa.grille,
            expa.date_depart as date_evenement,
            expa.etape as etape,
            min(expa.etape_date_debut) as etape_date_debut,
            max(expa.etape_date_fin) as etape_date_fin,
            count(distinct expa.fiche) as n_students
        from expansed as expa
        group by expa.date_depart, expa.id_eco, expa.grille, expa.etape

    -- Compute the daily delta between the new students, and the leavers.
    ),
    daily_students as (
        select
            coalesce(ing.id_eco, eg.id_eco) as id_eco,
            coalesce(ing.grille, eg.grille) as grille,
            coalesce(ing.date_evenement, eg.date_evenement) as date_evenement,
            coalesce(ing.n_students, 0) - coalesce(eg.n_students, 0) as delta,
            coalesce(ing.etape, eg.etape) as etape,
            coalesce(ing.etape_date_debut, eg.etape_date_debut) as etape_date_debut,
            coalesce(ing.etape_date_fin, eg.etape_date_fin) as etape_date_fin
        from ingress as ing
        full outer join
            egress as eg
            on ing.date_evenement = eg.date_evenement
            and ing.id_eco = eg.id_eco
            and ing.etape = eg.etape
            and ing.grille = eg.grille

    -- Compute the daily number of students by cumulating the delta
    -- The computation can be safely done grid * etape, without reporting the
    -- previsous value because the data have been expanded first.
    ),
    delta as (
        select
            date_evenement,
            id_eco,
            grille,
            etape,
            sum(delta) over (
                partition by id_eco, grille, etape
                order by date_evenement
                rows between unbounded preceding and current row
            ) as n_students_daily,
            etape_date_debut,
            etape_date_fin
        from daily_students
    )

select
    date_evenement,
    id_eco,
    grille,
    etape,
    etape_date_debut,
    etape_date_fin,
    n_students_daily
from delta
