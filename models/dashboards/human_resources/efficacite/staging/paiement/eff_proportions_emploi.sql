{{ config(materialized="table") }}

with
    -- Le statut actif est défini pour chaque année scolaire, du 1er juillet au 30 juin.
    etats_actifs as (
        select
            etat_empl,
            datefromparts(school_year, 7, 1) as debut,
            datefromparts(school_year + 1, 7, 1) as fin
        from {{ ref("dim_employment_status_yearly") }}
        where etat_actif = 1
    ),
    -- Conserver chaque date d’effet Paie pour retrouver le pourcentage principal et
    -- les lieux secondaires associés.
    -- stg_activity_history fusionne des périodes sans tenir compte des changements de
    -- répartition.
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
    -- Intersecter l'affectation avec la période de statut actif. La fin Paie est
    -- inclusive.
    periodes as (
        select
            h.*,
            case
                when h.date_eff > a.debut then h.date_eff else a.debut
            end as valid_from,
            borne.valid_until
        from historique h
        join
            etats_actifs a
            on a.etat_empl = h.etat
            and h.date_eff < a.fin
            and (h.date_fin >= a.debut or h.date_fin is null)
            and (h.suivant > a.debut or h.suivant is null)
            cross apply(
                select min(d) as valid_until
                from
                    (
                        values
                            (a.fin),
                            (h.suivant),
                            (
                                case
                                    when h.date_fin < a.fin
                                    then dateadd(day, 1, h.date_fin)
                                end
                            )
                    ) bornes(d)
            ) borne
        where h.date_eff < borne.valid_until
    ),
    -- Le pourcentage du lieu principal vient de l’historique d’emploi. Sans
    -- secondaire ni pourcentage déclaré, il reçoit 100 %.
    lieux as (
        select
            h.matr,
            h.ref_empl,
            h.corp_empl,
            h.valid_from,
            h.valid_until,
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

        -- Chaque lieu secondaire porte son propre pourcentage pour cette même date
        -- d’effet.
        union all

        select
            h.matr,
            h.ref_empl,
            h.corp_empl,
            h.valid_from,
            h.valid_until,
            s.lieu_trav,
            s.pourc_lieu_trav
        from periodes h
        join
            {{ ref("i_pai_hemp_lieu_trav_sec") }} s
            on h.matr = s.matr
            and h.ref_empl = s.ref_empl
            and h.date_eff = s.date_eff
    ),
    -- Écarter toute la période si une part manque ou si le total diffère de 100 %.
    controles as (
        select
            l.*,
            sum(pct) over (partition by matr, ref_empl, valid_from) as pct_total,
            min(
                case
                    when
                        pct between 0 and 100
                        and (pct = 0 or nullif(trim(lieu_trav), '') is not null)
                    then 1
                    else 0
                end
            ) over (partition by matr, ref_empl, valid_from) as valide
        from lieux l
    )
select
    l.matr as matricule,
    l.ref_empl,
    l.corp_empl,
    l.valid_from,
    l.valid_until,
    coalesce(m.lieu_jumele, l.lieu_trav) as lieu_jumele,
    sum(l.pct) / 100.0 as proportion
from controles l
left join {{ ref("eff_lieu_trav_to_lieu_jumele") }} m on m.lieu_trav = l.lieu_trav
where l.valide = 1 and l.pct_total = 100 and l.pct > 0
group by
    l.matr,
    l.ref_empl,
    l.corp_empl,
    l.valid_from,
    l.valid_until,
    coalesce(m.lieu_jumele, l.lieu_trav)
