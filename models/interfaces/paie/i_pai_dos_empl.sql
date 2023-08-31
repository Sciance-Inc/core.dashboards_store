select
    matr,
    date_entr,
    lieu_trav,
    stat_eng,  -- - indicator to filter. classification of regular posts to full or part-time employment. where if like S% - service, P% - Professional and E% - teacher
    ind_empl_princ,  -- indicator to filter ' if primary employee indicator is 1 then true'
    ref_empl,
    corp_empl,  -- indicator to filter -engagement status. abbreviations do not match between CSS, so it is suggested to use the description descr AS 'etat_description'
    etat,
    date_dern_jr_trav,
    date_eff,
    type
from {{ var("database_paie") }}.dbo.pai_dos_empl
