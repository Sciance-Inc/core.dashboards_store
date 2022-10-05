WITH spine AS (
    SELECT
        spi.annee,
        spi.fiche,
        spi.sk_eleve
    FROM {{ ref("base_spine") }} AS spi
    WHERE spi.sk_eleve_seqid = 1
)

SELECT
    el.fiche,
    el.annee,
    CASE 
        WHEN lower(el.cod_sexe_eleve) = 'f' THEN 0
        WHEN lower(el.cod_sexe_eleve) = 'm' THEN 1
        ELSE 99 
    END AS cod_sex_eleve,
    el.cod_niveau_scolaire,
    LEFT(RTRIM(el.cod_postal), 3) AS cod_fsa,
    CASE
        WHEN el.appartement IS NULL
        OR el.appartement = '' THEN 0
        ELSE 1
    END AS flag_appartement,
    el.duree_frequentation_jours
FROM {{ ref("i_dim_eleve") }} AS el
INNER JOIN spine AS spi
ON el.sk_eleve = spi.sk_eleve