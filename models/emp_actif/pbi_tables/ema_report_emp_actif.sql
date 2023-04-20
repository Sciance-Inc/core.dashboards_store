    {{ config(
    alias='report_emp_actif', 
    ) 
}}
    WITH empl_actif as (
	SELECT  
         util.matr
        ,nom                    
        ,prnom                  AS prenom
        ,adr_electrnq_portail   AS courriel_portail
        ,lieu.lieu_trav         AS lieu
        ,lieu.descr             AS desc_lieu
        ,corp.corp_empl         AS corp
        ,corp.descr             AS desc_corp
        ,etat.etat_empl         AS etat_empl
        ,etat.descr             AS desc_etat_empl
        ,empl.stat_eng          AS stat_eng
        ,eng.descr_stat_eng     AS desc_stat_eng
        ,etat
        ,ROW_NUMBER() OVER (PARTITION BY  util.matr,adr_electrnq_portail,lieu.lieu_trav
						ORDER BY date_eff DESC ) AS seqId   
                              
    FROM {{ ref("i_pai_dos") }}              AS util
        LEFT JOIN {{ ref('i_pai_dos_2') }}         AS info 
            ON util.matr = info.matr
        LEFT JOIN {{ ref('i_pai_dos_empl') }}      AS empl 
            ON empl.matr = util.matr            
        LEFT JOIN {{ ref('i_pai_tab_corp_empl') }} AS corp
            ON corp.corp_empl = empl.corp_empl
        LEFT JOIN {{ ref('i_pai_tab_lieu_trav') }} AS lieu
            ON lieu.lieu_trav = empl.lieu_trav                
        LEFT JOIN  {{ ref('i_pai_tab_stat_eng') }} AS eng
            ON eng.stat_eng = empl.stat_eng
        LEFT JOIN  {{ ref('i_pai_tab_etat_empl') }} AS etat
           ON etat.etat_empl = empl.etat    
                
    WHERE
        empl.ind_empl_princ = '1'          AND -- emploi principal
        adr_electrnq_portail IS NOT NULL   AND  
        etat_doss  ='A'                    AND -- Actif
        date_eff >='2020-07-01 00:00:00'   AND
        date_dern_paie > DATEADD (WEEK , -{{ var("emp_actif", {'nbrs_sem_dern_paie': 1})['nbrs_sem_dern_paie'] }}, getDate()) -- moins nombre de semaine: par défaut 1
    )

    SELECT  matr
            ,CONCAT(prenom,' ',nom)                     AS nom_empl
            ,courriel_portail
            ,CONCAT(lieu, ' - ',desc_lieu)              AS lieu_trav
            ,CONCAT(corp, ' - ',desc_corp)              AS corps_empl
            ,CONCAT(statut.etat_empl,' - ',desc_etat_empl)     AS etat_empl
            ,CONCAT(stat_eng, ' - ',desc_stat_eng)      AS stat_eng
    FROM empl_actif
    INNER JOIN  {{ ref('cstmrs_etat_empl') }} AS statut   ON statut.etat_empl = etat AND  statut.etat_actif = 1
    WHERE  seqId = 1