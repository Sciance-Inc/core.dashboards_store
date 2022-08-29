{# make sure the resolution unique per CodePerm, Annee, Freq #}
{% test resolution_cp_annee_freq(model) %}
SELECT
    val.*
FROM
    (
        SELECT
            CodePerm,
            Annee,
            Freq,
            COUNT(*) AS obs
        FROM
            {{ model }}
        GROUP BY CodePerm, Annee, Freq
    ) AS val
WHERE
    val.obs > 1 
{% endtest %}