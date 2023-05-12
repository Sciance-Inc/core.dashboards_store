
{{ config(alias='fact_emp_conge') }}

WITH employes AS (
    SELECT 
        CASE 
            WHEN MONTH(emp.date_eff) < 7 THEN YEAR(emp.date_eff) - 1 
            ELSE YEAR(emp.date_eff)
        END AS annee
        , emp.date_eff AS date_eff
        , emp.matr AS matricule
        , emp.lieu_trav
        , lieu.descr AS lieu_trav_descr
        , emp.corp_empl AS corps_emploi
        , corp.descr AS corps_demploi_description
        , emp.etat AS etat
        , etat.descr AS etat_description
        , empl_status.cong_lt
    FROM {{ ref('i_paie_hemp') }} AS emp
    INNER JOIN {{ ref('i_pai_tab_etat_empl') }} AS etat 
        ON emp.etat = etat.etat_empl
    INNER JOIN {{ ref('i_pai_tab_corp_empl') }} AS corp 
        ON emp.corp_empl = corp.corp_empl
    INNER JOIN {{ ref('i_pai_tab_lieu_trav') }}  AS lieu 
        ON emp.lieu_trav = lieu.lieu_trav   
    INNER JOIN {{ ref('etat_empl') }} AS empl_status
        ON emp.etat = empl_status.etat_empl
    WHERE empl_status.empl_cong = 1 --Empl en congé  
),

row_num AS (
	SELECT 
        *
		, ROW_NUMBER() OVER (PARTITION BY annee, matricule, etat ORDER BY date_eff DESC) AS seqid
	FROM employes
), 

columns AS (
    SELECT 
        date_eff
        , annee
        , matricule
        , lieu_trav
        , lieu_trav_descr
        , corps_emploi
        , corps_demploi_description
        , etat_description 
        , cong_lt
    FROM row_num
    WHERE seqid = 1
)

SELECT * FROM columns

