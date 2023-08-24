{{
    config(alias='fact_freq_fga')
}}

SELECT 
	el.code_perm
    , freq.fiche
    , freq.annee
    , freq.freq
    , freq.date_deb 
    , freq.date_fin
    , freq.org
    , freq.eco_cen
    , freq.bat
    , freq.prog
    , prog.descr_prog
    , freq.service_enseign
    , descr.cf_descr
FROM {{ ref('i_e_freq') }} AS freq
LEFT JOIN {{ ref('i_e_ele') }} AS el 
    ON freq.fiche = el.fiche
LEFT JOIN {{ ref('i_t_prog') }} AS prog 
    ON freq.prog = prog.prog
LEFT JOIN {{ ref('i_t_wl_descr') }} AS descr 
    ON freq.service_enseign = descr.code
WHERE 
    freq.client = '3'                                        -- Clientele 3 = FGA
    AND freq.date_deb != ''                                  -- date_deb obligatoire pour chaque CSS?
    AND (freq.service_enseign != '' OR freq.prog != '')       -- Avoir au moins un de ces 2 champs de ok
    AND descr.nom_table = 'X_ServiceEnseign'