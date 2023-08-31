{#
    Extract the grades from the e_ri_resultats and adapt them to fit with local exam table  .
#}
{{ config(alias="fact_evaluations_minist_sec4_sec5", schema="res_epreuves_staging") }}
with
    resmin as (
        select distinct
            fiche,
            ecole,
            matiere as code_matiere,
            annee,
            res_off_conv as resultat,
            res_off_conv as resultat_numerique,
            case when res_off_conv > 59 then 'R' else 'E' end as code_reussite
        from {{ ref("i_e_ri_resultats") }} as resmin
        where
            mois_resultat = '6'
            and annee not in ('2019', '2020')
            and type_form_charl = 'FG'
            and secteur_enseign_freq = 'JE'
            and ecole like ('{{ var("res_epreuves")["cod_css"] }}')
            and res_off_conv != ''
    )
select *
from resmin
