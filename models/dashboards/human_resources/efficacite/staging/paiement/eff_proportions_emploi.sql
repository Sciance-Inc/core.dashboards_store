{{ config(materialized="table") }}

with
    etats_actifs as (
        select
            etat_empl,
            school_year as annee,
            datefromparts(school_year, 7, 1) as debut,
            datefromparts(school_year + 1, 6, 30) as fin
        from {{ ref("dim_employment_status_yearly") }}
        where etat_actif = 1
    ),
    historique as (
        select
            matr,
            ref_empl,
            corp_empl,
            etat,
            lieu_trav,
            pourc_lieu_trav,
            date_eff,
            date_fin,
            lead(date_eff) over (
                partition by matr, ref_empl order by date_eff
            ) as suivant
        from {{ ref("i_pai_hemp") }}
    ),
    periodes as (
        select h.*, borne.fin
        from
            historique h
            cross apply(
                select min(d) as fin
                from
                    (
                        values
                            (h.date_fin),
                            (dateadd(day, -1, h.suivant)),
                            (cast(getdate() as date))
                    ) v(d)
            ) borne
        where h.date_eff <= borne.fin
    ),
    lieux as (
        select
            h.matr,
            h.ref_empl,
            h.corp_empl,
            h.etat,
            h.date_eff,
            h.fin,
            h.lieu_trav,
            case
                when s.matr is null and coalesce(h.pourc_lieu_trav, 0) = 0
                then 100
                else h.pourc_lieu_trav
            end as pct
        from periodes h
        left join
            (
                select distinct matr, ref_empl, date_eff
                from {{ ref("i_pai_hemp_lieu_trav_sec") }}
            ) s
            on h.matr = s.matr
            and h.ref_empl = s.ref_empl
            and h.date_eff = s.date_eff

        union all

        select
            h.matr,
            h.ref_empl,
            h.corp_empl,
            h.etat,
            h.date_eff,
            h.fin,
            s.lieu_trav,
            s.pourc_lieu_trav
        from periodes h
        join
            {{ ref("i_pai_hemp_lieu_trav_sec") }} s
            on h.matr = s.matr
            and h.ref_empl = s.ref_empl
            and h.date_eff = s.date_eff
    ),
    controles as (
        select l.*, sum(pct) over (partition by matr, ref_empl, date_eff) as pct_total
        from lieux l
    ),
    poids as (
        select
            a.annee,
            l.matr,
            l.ref_empl,
            l.corp_empl,
            coalesce(m.lieu_jumele, l.lieu_trav) as lieu_jumele,
            min(
                case
                    when
                        l.pct_total = 100
                        and l.pct between 0 and 100
                        and (l.pct = 0 or nullif(trim(l.lieu_trav), '') is not null)
                    then 1
                    else 0
                end
            ) as valide,
            sum(
                l.pct * (
                    1 + datediff(
                        day,
                        case when l.date_eff > a.debut then l.date_eff else a.debut end,
                        case when l.fin < a.fin then l.fin else a.fin end
                    )
                )
            ) as poids
        from controles l
        join
            etats_actifs a
            on a.etat_empl = l.etat
            and l.date_eff <= a.fin
            and l.fin >= a.debut
        left join
            {{ ref("eff_lieu_trav_to_lieu_jumele") }} m on m.lieu_trav = l.lieu_trav
        group by
            a.annee,
            l.matr,
            l.ref_empl,
            l.corp_empl,
            coalesce(m.lieu_jumele, l.lieu_trav)
    ),
    proportions as (
        select
            *,
            min(valide) over (
                partition by annee, matr, ref_empl, corp_empl
            ) as annee_valide,
            sum(poids) over (
                partition by annee, matr, ref_empl, corp_empl
            ) as poids_total
        from poids
    )
select
    annee,
    matr as matricule,
    ref_empl,
    corp_empl,
    lieu_jumele,
    cast(poids as float) / nullif(poids_total, 0) as proportion
from proportions
where annee_valide = 1 and poids > 0
