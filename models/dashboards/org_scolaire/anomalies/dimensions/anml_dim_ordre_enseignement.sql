-- description pour les ordres d'enseignments
select
    code as ordre_ens,
    cf_descr as desc_ordre_ens,
    {# case
        when code in (1, 2) then 12 when code = 3 then 30 when code = 4 then 40
    end code_agg_ordre_ens, #}
    case
        when code in (1, 2)
        then 'Préscolaire'  -- intégrer préscolaire 4 ans et préscolaire 5 ans à Préscolaire 
        when code in (3, 4)
        then cf_descr
    end desc_combiner_ordre_ens
from {{ ref("i_wl_descr") }}
where nom_table = 'ORDRE_ENS'
