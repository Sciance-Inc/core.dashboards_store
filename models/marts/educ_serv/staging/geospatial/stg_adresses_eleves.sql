{#
dashboards store - helping students, one dashboard at a time.
copyright (c) 2023  sciance inc.

this program is free software: you can redistribute it and/or modify
it under the terms of the gnu affero general public license as
published by the free software foundation, either version 3 of the
license, or any later version.

this program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  see the
gnu affero general public license for more details.

you should have received a copy of the gnu affero general public license
along with this program.  if not, see <https://www.gnu.org/licenses/>.
#}
with
    adr as (
        select
            fiche,
            type_adr,
            cast(date_effect as date) as date_effect,
            date_fin,
            ind_envoi_meq,
            code_post,
            row_number() over (partition by fiche order by date_effect) as seqid  -- pour identifier la 1ere adresse
        from {{ ref("i_e_adr") }}
        where date_effect != date_fin

    -- fiches avec un seul type d'adresse -> on considere tt les adresses
    ),
    adr2 as (
        select fiche, count(distinct type_adr) as nb_type_adr from adr group by fiche

    -- fiches avec un plusieurs types d'adresse -> on considere uniquement celles avec
    -- un ind_envoi_meq de 1 (sauf date initiale)
    ),
    adr3 as (
        select *
        from adr
        where
            fiche in (select distinct fiche from adr2 where nb_type_adr != 1)
            and ind_envoi_meq = 1
            and seqid != 1

    -- adresses à considerer
    ),
    adr4 as (
        select *
        from adr
        where
            seqid = 1
            or fiche in (select distinct fiche from adr2 where nb_type_adr = 1)
        union all
        select *
        from adr3

    -- modifier les dates effectives avec les adresses conservées
    ),
    adr5 as (
        select
            fiche,
            date_effect,
            case
                when
                    (lead(date_effect) over (partition by fiche order by date_effect))
                    is null
                then getdate()
                else
                    dateadd(
                        day,
                        -1,
                        lead(date_effect) over (partition by fiche order by date_effect)
                    )
            end as date_effect_fin,
            code_post
        from adr4

    -- identifier les annees scolaire d'appartenance de chaque CP
    ),
    y_sco as (
        select
            fiche,
            date_effect,
            date_effect_fin,
            case
                when month(date_effect) <= 6
                then year(date_effect) - 1
                else year(date_effect)
            end as annee_sco_deb,
            case
                when month(date_effect_fin) < 9
                then year(date_effect_fin) - 1
                else year(date_effect_fin)
            end as annee_sco_fin,
            code_post
        from adr5

    -- recuperer les annees scolaire de debut et de fin pour chaque fiche
    ),
    tab as (
        select
            fiche,
            min(annee_sco_deb) as annee_sco_deb,
            max(annee_sco_fin) as annee_sco_fin
        from y_sco
        group by fiche

    -- generer une table fiche/annee et joindre les CP
    ),
    long as (
        select t.fiche, t.annee_sco_deb + number as annee
        from tab as t
        join
            master..spt_values n
            on type = 'p'
            and number between 0 and t.annee_sco_fin - t.annee_sco_deb

    -- generer un seq_id pour garder le cp le plus recent
    ),
    last_cp as (
        select
            long.fiche,
            long.annee,
            y_sco.code_post,
            case
                when
                    datefromparts(long.annee, 9, 30)
                    between y_sco.date_effect and y_sco.date_effect_fin
                then 1
                else 0
            end as adresse_30sept,
            row_number() over (
                partition by long.fiche, long.annee order by y_sco.date_effect desc
            ) as seqid
        from long
        left join
            y_sco
            on y_sco.fiche = long.fiche
            and long.annee between y_sco.annee_sco_deb and y_sco.annee_sco_fin
    )

select
    t1.fiche, t1.annee, t1.code_post as last_code_post, t2.code_post as code_post_30sept
from last_cp as t1
left join
    (select * from last_cp where adresse_30sept = 1) as t2  -- adresse enregistré le 30 septembre
    on t2.fiche = t1.fiche
    and t2.annee = t1.annee
where t1.seqid = 1  -- adresse courante par annee
