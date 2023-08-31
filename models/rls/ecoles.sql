{{
    config(
        alias="ecoles",
    )
}}

with
    ecoles as (
        select distinct lieu_trav, descr as lieu_trav_desc
        from {{ ref("i_pai_tab_lieu_trav") }}

        where
            -- Écoles seulement (les autres ce sont des services)
            eco_off is not null
    )

select *
from ecoles
