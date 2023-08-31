select
    stat_eng as engagement_status,
    concat(descr, ' - (', stat_eng, ')') as engagement_status_name
from {{ ref("stat_eng") }}
