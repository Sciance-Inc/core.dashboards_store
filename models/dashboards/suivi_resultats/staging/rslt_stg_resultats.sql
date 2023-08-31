{{ config(alias="stg_resultats") }}

-- TODO : add and flag 'reprises'
-- Select the most recent results per student per course, excluding the summer reprises
with
    uptodate as (
        select
            annee,
            fiche,
            course_code,
            resultat,
            resultat_numerique,
            code_reussite,
            row_number() over (
                partition by annee, fiche, code_matiere order by rid desc
            ) as seqid  -- The seqId is used to keep the most up-to-date row
        from {{ ref("i_resultats_matieres_eleve") }} as res
        inner join
            {{ ref("tracked_courses") }} as dim on res.code_matiere = dim.course_code  -- Only keep the tracked courses
        where
            -- TODO : refactor to properly flag and handle `reprises`
            groupe_matiere not in ('H0', 'F0')  -- Summer reprise
            and resultat is not null
    )
-- A numerical result is requiered to properly compute the text color in the
-- dashboard. If (for a given student, year, course) there is no numerical result, I
-- compute one using the code_reussite as a proxy.
-- Get the numerical result if available or a proxy (0 or 100) if the course is not
-- sanctioned through a numerical result.
select
    annee,
    fiche,
    course_code,
    resultat,
    coalesce(
        resultat_numerique,
        case
            when code_reussite = 'E' then 0 when code_reussite = 'R' then 100 else null
        end
    ) as resultat_numerique
from uptodate
where seqid = 1
