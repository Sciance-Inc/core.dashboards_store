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

{# make sure the resolution unique per fiche / id_eco #}
{% test resolution_fiche_id_eco(model) %}
SELECT
    val.*
FROM
    (
        SELECT
            fiche,
            id_eco,
            COUNT(*) AS obs
        FROM
            {{ model }}
        GROUP BY 
            fiche,
            id_eco
    ) AS val
WHERE
    val.obs > 1 
{% endtest %}