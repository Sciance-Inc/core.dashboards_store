SELECT Annee
    ,CODE_SIMUL
    ,CODE_CONTRAT
    ,TYPE_CONTRAT
    ,DESCR
    ,CODE_TRANSP
    ,CODE_CAL
    ,DATE_DEB
    ,DATE_FIN
    ,POSTE_BUD_AM_PM_REG
    ,DATE_MODIF
FROM 
    {{ var("database_piastre") }}.dbo.PIA_CONTRAT