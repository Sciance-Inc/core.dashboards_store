{#
  Map each job_group to a job_group_category.

  Feel free to override me to get your own custom litle mapping.
#}
select
    corp_empl as job_group,
    descr as job_group_description,
    case
        when corp_empl like ('1%')
        then 'Direction'
        when corp_empl like ('2%')
        then 'Professionnel(le)'
        when corp_empl like ('3%')
        then 'Enseignant(e)'
        when corp_empl like ('4%')
        then 'Soutien'
        when corp_empl like ('5%')
        then 'Ressource matérielle'
        else 'Autres'
    end as job_group_category
from {{ ref("i_pai_tab_corp_empl") }} as src
