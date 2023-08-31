{{ config(alias="fact_rslt_mat_select") }}

with
    src as (
        select res.annee, res.fiche, res.ecole, dim.*, res.resultat_numerique
        from {{ ref("prspctf_dim_mat_selct") }} as dim
        left join
            {{ ref("i_resultats_matieres_eleve") }} as res
            on dim.code_matiere = res.code_matiere
        where resultat_numerique is not null
    )

select
    annee,
    fiche,
    niveau_scolaire,
    max(res_fr) as res_fr,
    max(res_maths) as res_maths,
    max(res_ang) as res_ang,
    max(res_sc) as res_sc,
    max(res_his) as res_his
from
    (
        select
            annee,
            fiche,
            niveau_scolaire,
            case when friendly_name = 'Français' then resultat_numerique end as res_fr,
            case when friendly_name = 'Maths' then resultat_numerique end as res_maths,
            case when friendly_name = 'Anglais' then resultat_numerique end as res_ang,
            case when friendly_name = 'Science' then resultat_numerique end as res_sc,
            case when friendly_name = 'Histoire' then resultat_numerique end as res_his
        from src

    ) as srctable
group by annee, fiche, niveau_scolaire
