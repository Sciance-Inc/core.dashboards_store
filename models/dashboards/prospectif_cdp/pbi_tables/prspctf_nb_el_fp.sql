{{ config(alias="nb_el_fp") }}

with
    src as (
        select code_perm, annee, eco_cen, date_deb, date_fin
        from {{ ref("prspctf_fact_freq_fp") }}
        where date_fin = ''

    )

{# Sum the number of students by population #}
select annee, eco_cen, count(distinct code_perm) as nb_eleves
from src
group by annee, eco_cen
