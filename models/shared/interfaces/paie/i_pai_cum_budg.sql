SELECT        
    MATR AS matricule
    , AN_BUDG AS annee_budgetaire
    , CUM as cumulatif 
    , CORP_EMPL AS corp_empl    
    , CODE_PMNT_DED AS code_pmnt_ded
FROM  {{ var("database_paie") }}.dbo.PAI_CUM_BUDG
