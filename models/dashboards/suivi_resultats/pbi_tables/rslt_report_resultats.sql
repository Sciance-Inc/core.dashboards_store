{{ config(alias='report_resultats') }}

with src AS (
SELECT 
    res.annee
    , res.fiche
    , el.nom_prenom_fiche
    , el.nom_ecole
    , el.groupe_repere
    , el.age_30_septembre
    , el.classification
    , res.niveau_scolaire
    , res.course_code
    , res.course_name
    , res.course_group
    , res.resultat
    , res.is_echec
    , res.is_difficulty
    , CASE WHEN res.annee = {{ store.get_current_year() }} THEN 1 ELSE 0 END AS is_current_year
    , CASE WHEN res.annee = {{ store.get_current_year() }} - 1 THEN 1 ELSE 0 END AS is_previous_year
    , CASE WHEN is_echec = 1 OR is_difficulty = 1 THEN 1 ELSE 0 END AS is_echec_or_difficulty
FROM {{ ref('rslt_fact_resultats') }} AS res
INNER JOIN {{ ref('rslt_dim_eleve') }} AS el
ON 
    res.annee = el.annee AND
    res.fiche = el.fiche

-- Keep all the failed courses belonging to a course group  
), course_group_failed AS (
    SELECT 
        src.annee
        , src.fiche
        , src.nom_prenom_fiche
        , src.nom_ecole
        , src.groupe_repere
        , src.age_30_septembre
        , src.classification
        , src.niveau_scolaire
        , src.course_code
        , src.course_name
        , src.course_group
        , src.resultat
        , src.is_echec
        , src.is_difficulty
        , src.is_echec_or_difficulty
        , MAX(src.is_echec_or_difficulty) OVER (PARTITION BY src.fiche, src.course_group) AS is_echec_or_difficulty_by_course_group
        , MAX(src.is_echec_or_difficulty) OVER (PARTITION BY src.fiche, src.course_group, src.annee) AS is_echec_or_difficulty_by_yearly_course_group
        , src.is_previous_year
        , src.is_current_year
    FROM src AS src

-- Attach a label / status to each student : is the student in difficulty this year ? Or was he already in difficulty the year before ? before before last year ?  Or is he succeding ?
-- To do so I need to first label each year independently, and then back-propagate the label to whole student history by reverse-priority

-- Attach the label
), labelled AS (
    SELECT 
        annee
        , fiche
        , nom_prenom_fiche
        , nom_ecole
        , groupe_repere
        , age_30_septembre
        , classification
        , niveau_scolaire
        , course_code
        , course_group
        , resultat
        , is_echec
        , is_difficulty
        , is_echec_or_difficulty
        , is_echec_or_difficulty_by_yearly_course_group
        , is_previous_year
        , is_current_year
        -- Compute, for each year, the student's status 
        , CASE
            WHEN is_current_year = 1 AND is_echec_or_difficulty_by_yearly_course_group = 1 THEN 0 --'en difficulté cette année'
            WHEN is_previous_year = 1 AND is_echec_or_difficulty_by_yearly_course_group = 1 THEN 1 -- 'en difficulté l`année dernière'
            WHEN is_echec_or_difficulty_by_course_group = 1 THEN 2 -- 'en difficulté avant à l`année dernière'
            WHEN is_echec_or_difficulty_by_course_group = 0 THEN 3 -- 'en reussite'
            ELSE 4 -- 'NULL
        END AS status_priority
    FROM course_group_failed

-- Backpropagate the Label
), backpropagated AS (
    SELECT 
        annee
        , fiche
        , nom_prenom_fiche
        , nom_ecole
        , groupe_repere
        , age_30_septembre
        , classification
        , niveau_scolaire
        , course_code
        , course_group
        , resultat
        , is_echec
        , is_difficulty
        , is_echec_or_difficulty
        , is_echec_or_difficulty_by_yearly_course_group
        , is_previous_year
        , is_current_year
        -- Take the labels with the highest priority (the lower the number, the higher the priority)
        , MIN(status_priority) OVER (PARTITION BY Course_group, fiche) AS status
    FROM labelled 
) 

SELECT 
    annee
    , fiche
    , nom_prenom_fiche
    , nom_ecole
    , groupe_repere
    , age_30_septembre
    , classification
    , niveau_scolaire
    , course_code -- Required by one of the tests
    , course_group
    , resultat
    , is_echec
    , is_difficulty
    , is_echec_or_difficulty
    , is_echec_or_difficulty_by_yearly_course_group
    , is_previous_year
    , is_current_year
    -- Replace the label with a friendly name
    , CASE
        WHEN status = 0 THEN 'en difficulté cette année'
        WHEN status = 1 THEN  'en difficulté l`année dernière'
        WHEN status = 2 THEN  'en difficulté avant à l`année dernière'
        WHEN status = 3 THEN  'en reussite'
        ELSE NULL 
    END AS status
FROM backpropagated 