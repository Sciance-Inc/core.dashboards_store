{{ config(alias="report_nb_ele_plus_de_66") }}

with
    filtr as (
        select
            annee, fiche, niveau_scolaire, res_fr, res_maths, res_ang, res_sc, res_his
        from {{ ref("prspctf_fact_rslt_mat_select") }}
        where
            niveau_scolaire != '2e cycle - secondaire'
            or (
                niveau_scolaire = '2e cycle - secondaire'
                and (
                    res_fr is not null
                    and res_maths is not null
                    and res_ang is not null
                    and res_sc is not null
                    and res_his is not null
                )
            )
    ),
    src as (
        select
            annee,
            fiche,
            niveau_scolaire,
            res_fr,
            res_maths,
            res_ang,
            res_sc,
            res_his,
            case
                when
                    (
                        niveau_scolaire = 'primaire'
                        or niveau_scolaire = '1er cycle - secondaire'
                    )
                    and res_fr > 66
                    and res_maths > 66
                then 1
                when
                    niveau_scolaire = '2e cycle - secondaire'
                    and res_fr > 66
                    and res_maths > 66
                    and res_ang > 66
                    and res_sc > 66
                    and res_his > 66
                then 1
                else 0
            end as ind_res_66
        from filtr
    )
select
    annee,
    sum(ind_res_66) as sm,
    count(ind_res_66) as nb,
    cast(
        (
            (cast(sum(ind_res_66) as float) / cast(count(ind_res_66) as float)) * 100
        ) as decimal(5, 2)
    ) as prop_res_66
from src
group by annee
