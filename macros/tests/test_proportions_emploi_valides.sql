{% test proportions_emploi_valides(model) %}
    select annee, matricule, ref_empl, corp_empl
    from {{ model }}
    group by annee, matricule, ref_empl, corp_empl
    having
        count(*) <> count(distinct lieu_jumele)
        or count(proportion) <> count(*)
        or min(proportion) <= 0
        or abs(sum(proportion) - 1.0) > 0.000000001
{% endtest %}
