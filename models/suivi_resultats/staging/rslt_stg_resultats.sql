{{ config(alias='stg_resultats') }}

-- TODO : add and flag 'reprises'

-- Select the most recent results per student per course, excluding the summer reprises
WITH upToDate AS (
    SELECT 
        annee
        , fiche
        , course_code
        , resultat
        , resultat_numerique
        , code_reussite
        , ROW_NUMBER() OVER (PARTITION BY annee, fiche, code_matiere ORDER BY rid DESC) AS seqId  -- The seqId is used to keep the most up-to-date row
    FROM {{ ref('i_resultats_matieres_eleve') }} AS res
    INNER JOIN {{ ref('tracked_courses') }} AS dim
    ON  res.code_matiere = dim.course_code  -- Only keep the tracked courses
    WHERE 
        -- TODO : refactor to properly flag and handle `reprises`
        groupe_matiere NOT IN ('H0', 'F0') -- Summer reprise
)
-- A numerical result is requiered to properly compute the text color in the dashboard. If (for a given student, year, course) there is no numerical result, I compute one using the code_reussite as a proxy.
-- Get the numerical result if available or a proxy (0 or 100) if the course is not sanctioned through a numerical result.
SELECT 
    annee
    , fiche
    , course_code
    , resultat
    , COALESCE(
        resultat_numerique, 
        CASE 
            WHEN code_reussite = 'E' THEN 0 
            WHEN code_reussite = 'R' THEN 100
            ELSE NULL
        END
    ) AS resultat_numerique
FROM upToDate
WHERE seqId = 1
