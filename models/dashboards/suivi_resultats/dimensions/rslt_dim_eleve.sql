WITH eleve AS (
    SELECT 
        fiche,
        CONCAT(nom, ', ', prenom, ' (', fiche, ')') AS nom_prenom_fiche,
        ROW_NUMBER() OVER (PARTITION BY fiche ORDER BY rid DESC) AS seqId
    FROM {{ ref('i_eleves') }}

), ecole AS (
    SELECT 
        annee,
        ecole,
        nom_ecole,
        ROW_NUMBER() OVER (PARTITION BY annee, ecole ORDER BY rid DESC) AS seqId
    FROM {{ ref('i_ecoles') }}

-- Extract the of fiche, annee for which we have data
), dos AS (
    SELECT 
        annee, 
        fiche
    FROM {{ ref('i_dossiers') }}
    WHERE 
        statut = 'A' AND 
        annee BETWEEN {{ store.get_current_year() }} - 4 AND {{ store.get_current_year() }}
    GROUP BY annee, fiche


-- Extract some static, student level metadata used for filtering
), meta AS (
    SELECT 
        src.fiche,
        src.ecole,
        src.niveau_scolaire,
        src.age_30_septembre,
        src.classification,
        src.groupe_repere
    FROM (
        SELECT 
            fiche,
            ecole,
            niveau_scolaire,
            age_30_septembre,
            classification,
            groupe_repere,
            ROW_NUMBER() OVER (PARTITION BY fiche ORDER BY annee DESC, rid ASC) AS seqId
        FROM {{ ref('i_dossiers') }}
    ) As src
    WHERE src.seqId = 1
)

SELECT 
    dos.annee,
    dos.fiche,
    ele.nom_prenom_fiche,
    eco.nom_ecole,
    meta.age_30_septembre,
    meta.classification,
    meta.groupe_repere
FROM dos AS dos
INNER JOIN (SELECT nom_prenom_fiche, fiche FROM eleve WHERE seqId = 1) AS ele 
ON ele.fiche = dos.fiche
INNER JOIN meta AS meta ON meta.fiche = dos.fiche
INNER JOIN (SELECT nom_ecole, ecole, annee FROM ecole WHERE seqId = 1) AS eco
ON eco.ecole = meta.ecole AND eco.annee = dos.annee
