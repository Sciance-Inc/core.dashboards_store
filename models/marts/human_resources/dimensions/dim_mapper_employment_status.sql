select
    etat_empl as employment_status,
    concat(descr, ' - (', etat_empl, ')') as employment_status_name
from {{ ref("etat_empl") }}
