{% test montants_paiements_conserves(model, compare_model) %}
    with
        montants as (
            select annee, total_mnt_brut as montant
            from {{ model }}
            union all
            select
                year(date_cheq_paiement)
                - case when month(date_cheq_paiement) <= 6 then 1 else 0 end as annee,
                - total_mnt_brut as montant
            from {{ compare_model }}
        )
    select annee
    from montants
    group by annee
    having abs(sum(cast(montant as decimal(38, 10)))) >= 0.005
{% endtest %}
