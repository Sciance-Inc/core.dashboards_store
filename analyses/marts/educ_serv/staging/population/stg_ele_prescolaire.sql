
SELECT DISTINCT 
    ele.code_perm
    , eco.id_eco
    , eco.annee
FROM {{ ref('i_gpm_e_dan') }} AS eledan
LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco
    ON eledan.id_eco = eco.id_eco
LEFT JOIN {{ ref('i_gpm_e_ele') }} AS ele
    ON eledan.fiche = ele.fiche    
/*WHERE 
    eledan.statut_don_an = 'A' AND (
        (
            eledan.ordre_ens = '1'
            AND eledan.grp_rep IN ('MA4','MA5','M41','M42')
        )

        OR (
            eledan.ordre_ens = '2'
            AND (eledan.grp_rep NOT LIKE '9%' OR eledan.grp_rep IS NULL)
            )
    )*/