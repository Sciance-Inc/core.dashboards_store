SELECT 
    Annee AS annee
    , code_simul
    , code_contrat
    , type_contrat
    , descr
    , code_transp
    , code_cal
    , date_deb
    , date_fin
    , poste_bud_am_pm_reg
    , date_modif
FROM 
    {{ var("database_piastre") }}.dbo.pia_contrat