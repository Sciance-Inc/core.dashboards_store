SELECT DISTINCT
    ele.code_perm
    , eco.id_eco
    , eco.annee
FROM {{ ref('i_gpm_e_dan') }} AS eledan
LEFT JOIN {{ ref('i_gpm_t_eco') }} AS eco
    ON eledan.id_eco = eco.id_eco
LEFT JOIN {{ ref('i_gpm_e_ele') }} AS ele
    ON eledan.fiche = ele.fiche
/*
WHERE
    eledan.statut_don_an = 'A'
    AND eco.eco NOT IN ('960')                                      -- Ignore les élèves qui sont inscrits à l'école virtuelle
    AND eco.eco NOT IN ('950')                                      -- Ignore les élèves hors territoire qui sont dans le processus de demande d'inscription dans une école du CSS
    AND eledan.ordre_ens = '3'                                      -- PRIMAIRE
    AND eledan.classe IN ('A','B','C','D','E','F','G','H','I')
    AND (eledan.grp_rep NOT IN ('999') OR eledan.grp_rep IS NULL)       -- Ignore l'enseignement réalisé à la maison par les parents
    AND (eledan.grp_rep NOT IN ('801','802') OR eledan.grp_rep IS NULL)   -- Ignore les élèves en classe d'accueil
    */