{% test proportions_emploi_valides(model) %}
    with
        periodes as (
            select
                matricule,
                ref_empl,
                corp_empl,
                valid_from,
                valid_until,
                count(*) as lieux,
                count(distinct lieu_jumele) as lieux_distincts,
                count(proportion) as parts,
                min(proportion) as minimum,
                sum(proportion) as total,
                lead(valid_from) over (
                    partition by matricule, ref_empl, corp_empl
                    order by valid_from, valid_until
                ) as debut_suivant
            from {{ model }}
            group by matricule, ref_empl, corp_empl, valid_from, valid_until
        )
    select *
    from periodes
    where
        valid_from is null
        or valid_until is null
        or valid_from >= valid_until
        or valid_until > debut_suivant
        or lieux <> lieux_distincts
        or parts <> lieux
        or minimum <= 0
        or abs(total - 1.0) > 0.000000001
{% endtest %}
