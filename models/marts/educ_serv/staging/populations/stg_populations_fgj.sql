{{ config(alias="stg_populations_fgj") }}

select code_perm, id_eco, annee, 'prescolaire' as population
from {{ source_or_ref("populations", "stg_ele_prescolaire") }}
union
select code_perm, id_eco, annee, 'primaire_reg' as population
from {{ source_or_ref("populations", "stg_ele_primaire_reg") }}
union
select code_perm, id_eco, annee, 'primaire_adapt' as population
from {{ source_or_ref("populations", "stg_ele_primaire_adapt") }}
union
select code_perm, id_eco, annee, 'secondaire_reg' as population
from {{ source_or_ref("populations", "stg_ele_secondaire_reg") }}
union
select code_perm, id_eco, annee, 'secondaire_adapt' as population
from {{ source_or_ref("populations", "stg_ele_secondaire_adapt") }}
union
select code_perm, id_eco, annee, population
from {{ ref("custom_fgj_populations") }}
