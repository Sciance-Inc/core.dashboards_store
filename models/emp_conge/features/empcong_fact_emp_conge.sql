
{{ config(alias='fact_emp_conge') }}

WITH employes AS (
    SELECT DISTINCT
        CASE 
            WHEN MONTH(emp.date_eff) < 8 THEN YEAR(emp.date_eff) - 1 
            ELSE YEAR(emp.date_eff)
        END AS 'annee'
        , emp.matr
        , emp.lieu_trav AS 'ecole_code'
        , lieu.descr AS 'ecole_description'
        , emp.corp_empl AS 'corps_emploi'
        , corpe.descr AS 'corps_demploi_description'
        , emp.etat
        , etat.descr AS 'etat_description'
    FROM {{ ref('i_paie_hemp') }} AS emp

    INNER JOIN {{ ref('i_pai_tab_etat_empl_conge') }} AS etat 
        ON emp.etat = etat.etat_empl
    INNER JOIN {{ ref('i_pai_tab_corp_empl') }} AS corpe 
        ON emp.corp_empl = corpe.corp_empl
    INNER JOIN {{ ref('i_pai_tab_lieu_trav') }}  AS lieu 
        ON emp.lieu_trav = lieu.lieu_trav    
    WHERE
        (
            etat.etat_empl = 'A02' OR
            etat.etat_empl = 'A07' OR
            etat.etat_empl = 'A08' OR 
            etat.etat_empl = 'A11' OR 
            etat.etat_empl = 'A13' OR 
            etat.etat_empl = 'A20' OR 
            etat.etat_empl = 'A21' OR 
            etat.etat_empl = 'P01' OR 
            etat.etat_empl = 'P03' OR 
            etat.etat_empl = 'P04' OR 
            etat.etat_empl = 'P06' OR 
            etat.etat_empl = 'S01' OR 
            etat.etat_empl = 'S02' OR 
            etat.etat_empl = 'S09' OR 
            etat.etat_empl = 'S16' OR 
            etat.etat_empl = 'S20'
            )       
)

SELECT * FROM employes

WHERE annee BETWEEN {{  tbe.get_current_year() }} - 10 AND {{  tbe.get_current_year() }}