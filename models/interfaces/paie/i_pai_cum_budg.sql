select
    matr as matricule,
    an_budg as annee_budgetaire,
    cum as cumulatif,
    corp_empl as corp_empl,
    code_pmnt_ded as code_pmnt_ded
from {{ var("database_paie") }}.dbo.pai_cum_budg
