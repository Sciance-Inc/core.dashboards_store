    WITH utilisateurs_ecoles as (
	SELECT  
         util.matr
        ,nom
        ,prnom                  AS prenom
        ,adr_electrnq_portail   AS courriel_portail
        ,lieu.lieu_trav         AS code_ecole
        ,lieu.descr             AS desc_ecole
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

    WHERE
        etat NOT LIKE  'C%'                AND
        adr_electrnq_portail IS NOT NULL   AND
        etat_doss  ='A'                    AND -- Actif
        date_eff >='2020-07-01 00:00:00'   AND
        (corp.corp_empl LIKE '1%' OR corp.corp_empl LIKE '3%') AND
	   eco_off IS NOT NULL    -- Écoles seulement
    )

    SELECT matr,nom,prenom,courriel_portail,code_ecole,desc_ecole FROM utilisateurs_ecoles WHERE seqId =1
