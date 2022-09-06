WITH src AS (
    SELECT 
        CodePerm
        , Annee
        , Freq
        , DateDeb
        , DateFin
        , population
    FROM {{ ref('stg_populations') }} AS pop

)

SELECT 
    *
    , ROW_NUMBER() OVER (PARTITION BY CodePerm, Annee, population ORDER BY Freq DESC) AS seqid
FROM src