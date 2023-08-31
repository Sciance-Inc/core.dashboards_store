{{ config(alias="fact_freq_fp") }}

select
    el.code_perm,
    freq.fiche,
    freq.annee,
    freq.freq,
    freq.date_deb,
    freq.date_fin,
    freq.org,
    freq.eco_cen,
    freq.bat,
    freq.prog,
    prog.descr_prog
from {{ ref("i_e_freq") }} as freq
left join {{ ref("i_e_ele") }} as el on freq.fiche = el.fiche
left join {{ ref("i_t_prog") }} as prog on freq.prog = prog.prog
where
    freq.client = '4'  -- Clientele 4 = FP
    and freq.date_deb != ''  -- date_deb obligatoire pour chaque CSS?
    and freq.prog != ''  -- Avoir au moins un de ces 2 champs de ok
