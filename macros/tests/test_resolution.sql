{# make sure the resolution unique per fiche / annee #}
{% test resolution_fiche_annee(model) %}
SELECT
    val.*
FROM
    (
        SELECT
            fiche,
            annee,
            COUNT(*) AS obs
        FROM
            {{ model }}
        GROUP BY 
            fiche,
            annee
    ) AS val
WHERE
    val.obs > 1 
{% endtest %}