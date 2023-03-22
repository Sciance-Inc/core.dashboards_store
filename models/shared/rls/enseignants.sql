
{{ config(
    alias='enseignants', 
    ) 
}}

WITH directeurs AS (
    SELECT DISTINCT
         util.matr
        ,nom
        ,prnom                  AS prenom
        ,adr_electrnq_portail   AS courriel_portail
    FROM {{ ref("i_pai_dos") }}              AS util
        INNER JOIN {{ ref('i_pai_dos_2') }}          AS info 
            ON util.matr = info.matr
        INNER JOIN {{ ref('i_pai_dos_empl') }}      AS empl 
            ON empl.matr = util.matr            
        INNER JOIN {{ ref('i_pai_tab_corp_empl') }} AS corp
            ON corp.corp_empl = empl.corp_empl
 
    WHERE
        ind_empl_princ = '1'               AND
        etat NOT LIKE  'C%'                AND
        adr_electrnq_portail IS NOT NULL   AND
        etat_doss  ='A'                    AND
        date_eff >='2020-07-01 00:00:00'  AND
        corp.corp_empl LIKE '3%'                     
    )

SELECT * FROM directeurs