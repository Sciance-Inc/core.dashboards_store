{{ config(alias='stg_spine') }}

-- Select the most up-to-date dossier for the last 5 years
WITH dossierSeqId AS (
    SELECT 
        annee, 
        fiche,
        statut,
        niveau_scolaire,
        ROW_NUMBER() OVER (PARTITION BY fiche, annee ORDER BY rid DESC) AS seqId
    FROM {{ ref('i_dossiers') }} 
    WHERE 
        statut = 'A' AND 
        annee BETWEEN {{ store.get_current_year() }}  - 4 AND {{ store.get_current_year() }}

-- Fetch all the students with at least a result during the considered timeframe
), students AS (
SELECT 
    DISTINCT fiche
FROM {{ ref('rslt_stg_resultats') }} 
WHERE 
    annee BETWEEN {{ store.get_current_year() }} - 4 AND {{ store.get_current_year() }} AND
    resultat_numerique IS NOT NULL OR 
    resultat IS NOT NULL

-- Keep the student currently enrolled in the CSS (first cycle of the secondary )
), enrolled AS (
SELECT 
    dos.fiche
FROM dossierSeqId AS dos
WHERE 
    seqId = 1 AND
    annee = {{ store.get_current_year() }} AND
    niveau_scolaire IN (SELECT level FROM {{ ref('tracked_levels') }})
)

-- Extract the history for all the students with a result in the last 5 years and currently enrolled in the CSS
SELECT 
    dos.annee
    , dos.fiche
    , dos.niveau_scolaire
FROM dossierSeqId AS dos
INNER JOIN students AS stu ON stu.fiche = dos.fiche
INNER JOIN enrolled AS enr ON enr.fiche = dos.fiche
WHERE dos.seqId = 1
