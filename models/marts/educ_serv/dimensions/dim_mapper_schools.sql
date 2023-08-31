{#
  Map each school to it's friendly name.

  Feel free to override me to get your own custom litle mapping.
#}
select id_eco, annee, eco, concat('(', eco, ') - ', nom_eco) as school_friendly_name
from {{ ref("i_gpm_t_eco") }}
