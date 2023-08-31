{{ config(alias="report_resultats") }}

with
    src as (
        select
            res.annee,
            res.fiche,
            el.nom_prenom_fiche,
            el.nom_ecole,
            el.groupe_repere,
            el.age_30_septembre,
            el.classification,
            res.niveau_scolaire,
            res.course_code,
            res.course_name,
            res.course_group,
            res.resultat,
            res.is_echec,
            res.is_difficulty,
            case
                when res.annee = {{ store.get_current_year() }} then 1 else 0
            end as is_current_year,
            case
                when res.annee = {{ store.get_current_year() }} - 1 then 1 else 0
            end as is_previous_year,
            case
                when is_echec = 1 or is_difficulty = 1 then 1 else 0
            end as is_echec_or_difficulty
        from {{ ref("rslt_fact_resultats") }} as res
        inner join
            {{ ref("rslt_dim_eleve") }} as el
            on res.annee = el.annee
            and res.fiche = el.fiche

    -- Keep all the failed courses belonging to a course group  
    ),
    course_group_failed as (
        select
            src.annee,
            src.fiche,
            src.nom_prenom_fiche,
            src.nom_ecole,
            src.groupe_repere,
            src.age_30_septembre,
            src.classification,
            src.niveau_scolaire,
            src.course_code,
            src.course_name,
            src.course_group,
            src.resultat,
            src.is_echec,
            src.is_difficulty,
            src.is_echec_or_difficulty,
            max(src.is_echec_or_difficulty) over (
                partition by src.fiche, src.course_group
            ) as is_echec_or_difficulty_by_course_group,
            max(src.is_echec_or_difficulty) over (
                partition by src.fiche, src.course_group, src.annee
            ) as is_echec_or_difficulty_by_yearly_course_group,
            src.is_previous_year,
            src.is_current_year
        from src as src

    -- Attach a label / status to each student : is the student in difficulty this
    -- year ? Or was he already in difficulty the year before ? before before last
    -- year ?  Or is he succeding ?
    -- To do so I need to first label each year independently, and then back-propagate
    -- the label to whole student history by reverse-priority
    -- Attach the label
    ),
    labelled as (
        select
            annee,
            fiche,
            nom_prenom_fiche,
            nom_ecole,
            groupe_repere,
            age_30_septembre,
            classification,
            niveau_scolaire,
            course_code,
            course_group,
            resultat,
            is_echec,
            is_difficulty,
            is_echec_or_difficulty,
            is_echec_or_difficulty_by_yearly_course_group,
            is_previous_year,
            is_current_year,
            -- Compute, for each year, the student's status 
            case
                when
                    is_current_year = 1
                    and is_echec_or_difficulty_by_yearly_course_group = 1
                then 0  -- 'en difficulté cette année'
                when
                    is_previous_year = 1
                    and is_echec_or_difficulty_by_yearly_course_group = 1
                then 1  -- 'en difficulté l`année dernière'
                when is_echec_or_difficulty_by_course_group = 1
                then 2  -- 'en difficulté avant à l`année dernière'
                when is_echec_or_difficulty_by_course_group = 0
                then 3  -- 'en reussite'
                else 4  -- 'NULL
            end as status_priority
        from course_group_failed

    -- Backpropagate the Label
    ),
    backpropagated as (
        select
            annee,
            fiche,
            nom_prenom_fiche,
            nom_ecole,
            groupe_repere,
            age_30_septembre,
            classification,
            niveau_scolaire,
            course_code,
            course_group,
            resultat,
            is_echec,
            is_difficulty,
            is_echec_or_difficulty,
            is_echec_or_difficulty_by_yearly_course_group,
            is_previous_year,
            is_current_year,
            -- Take the labels with the highest priority (the lower the number, the
            -- higher the priority)
            min(status_priority) over (partition by course_group, fiche) as status
        from labelled
    )

select
    annee,
    fiche,
    nom_prenom_fiche,
    nom_ecole,
    groupe_repere,
    age_30_septembre,
    classification,
    niveau_scolaire,
    course_code,  -- Required by one of the tests
    course_group,
    resultat,
    is_echec,
    is_difficulty,
    is_echec_or_difficulty,
    is_echec_or_difficulty_by_yearly_course_group,
    is_previous_year,
    is_current_year,
    -- Replace the label with a friendly name
    case
        when status = 0
        then 'en difficulté cette année'
        when status = 1
        then 'en difficulté l`année dernière'
        when status = 2
        then 'en difficulté avant à l`année dernière'
        when status = 3
        then 'en reussite'
        else null
    end as status
from backpropagated
