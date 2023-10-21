SELECT
    dat_naissance_eleve
    , age_30_septembre
FROM {{ ref('i_dim_eleve')}}