{{
    config(alias='fact_freq_fp')
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
FROM {{ ref('i_e_freq') }} AS freq
LEFT JOIN {{ ref('i_e_ele') }} AS el 
    ON freq.fiche = el.fiche
LEFT JOIN {{ ref('i_t_prog') }} AS prog 
    ON freq.prog = prog.prog
WHERE 
    freq.client = '4'                                        -- Clientele 4 = FP
    AND freq.date_deb != ''                                  -- date_deb obligatoire pour chaque CSS?
    AND freq.prog != ''                                      -- Avoir au moins un de ces 2 champs de ok