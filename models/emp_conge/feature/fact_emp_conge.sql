with employes as (
    select DISTINCT
        CASE 
            WHEN MONTH(emp.date_eff) < 8 THEN YEAR(emp.date_eff) - 1 
            ELSE YEAR(emp.date_eff)
        END AS 'annee'
        , emp.matr
        , emp.lieu_trav as 'ecole_code'
        , lieu.descr as 'ecole_description'
        , emp.corp_empl as 'corps_emploi'
        , corpe.descr as 'corps_demploi_description'
        , emp.etat
        , etat.descr as 'etat_description'
    from {{ ref('stg_paie_hemp') }} as emp

    inner join {{ ref('stg_pai_tab_etat_empl_conge') }} as etat on emp.etat = etat.etat_empl
    inner join {{ ref('stg_pai_tab_corp_empl') }} as corpe on emp.corp_empl = corpe.corp_empl
    inner join {{ ref('stg_pai_tab_lieu_trav') }}  as lieu on emp.lieu_trav = lieu.lieu_trav    
)

select * from employes

where annee between {{  tbe.get_current_year() }} - 10 and {{  tbe.get_current_year() }}