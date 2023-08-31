select lieu_trav as workplace, concat(descr, ' - (', lieu_trav, ')') as workplace_name
from {{ ref("i_pai_tab_lieu_trav") }}
