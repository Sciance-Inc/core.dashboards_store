{{ config(alias="fact_resultats") }}

select
    spi.annee,
    spi.fiche,
    spi.niveau_scolaire,
    dim.course_code,
    dim.course_name,
    dim.course_group,
    res.resultat,
    case when res.resultat_numerique < 60 then 1 else 0 end as is_echec,
    case
        when res.resultat_numerique >= 60 and res.resultat_numerique < 66 then 1 else 0
    end as is_difficulty
-- TODO : add an populate a is_reprise flag
from {{ ref("rslt_stg_spine") }} as spi
left join
    {{ ref("rslt_stg_resultats") }} as res
    on spi.fiche = res.fiche
    and spi.annee = res.annee
inner join
    {{ ref("tracked_courses") }} as dim
    on res.course_code = dim.course_code
    and spi.niveau_scolaire = dim.level  -- Only keep the results for the courses corresponding to the level the student is enrolled in
