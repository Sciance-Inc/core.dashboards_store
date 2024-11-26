{#
CDPVD Dashboards store
Copyright (C) 2024 CDPVD.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
#}
-- Création de l'année brut pour une manipulation future
with
    _mentions as (
        select
            mentions.fiche,
            mentions.code_perm,
            mentions.prog_charl,
            cast(left(mentions.date_exec_sanct, 4) as int) as annee_brute,
            cast(right(left(mentions.date_exec_sanct, 6), 2) as int) as mois_brut,
            mentions.ind_reus_sanct_charl,
            mentions.regime_sanct_charl,
            mentions.date_exec_sanct
        from {{ ref("i_e_ri_mentions") }} as mentions
    ),

    -- Création de la notion de l'année dans e_ri_mentions
    mentions_annee as (
        select
            mentions.fiche,
            mentions.code_perm,
            mentions.prog_charl,
            mentions.regime_sanct_charl,
            mentions.date_exec_sanct,
            case
                when mentions.mois_brut between 9 and 12  -- Entre septembre et Décembre
                then mentions.annee_brute
                when mentions.mois_brut between 1 and 8  -- Entre Janvier et Août
                then mentions.annee_brute - 1
            end as annee,
            case
                when mentions.ind_reus_sanct_charl = 'O' then 1.0 else 0.0
            end as 'ind_obtention',
            case when prog.type_diplome = 'DES' then 1.0 else 0.0 end as 'indice_Des',
            case when prog.type_diplome = 'CFPT' then 1.0 else 0.0 end as 'indice_Cfpt',
            case when prog.type_diplome = 'CFMS' then 1.0 else 0.0 end as 'indice_Cfms'
        from _mentions as mentions
        inner join {{ ref("i_t_prog") }} as prog on mentions.prog_charl = prog.prog_meq
    ),

    _row_num as (
        Select
            *,
            row_number() over ( partition by code_perm, fiche, annee order by annee asc) as seqid
        from mentions_annee
    )

select
    code_perm,
    fiche,
    prog_charl,
    annee,
    ind_obtention,
    regime_sanct_charl,
    date_exec_sanct,
    indice_des,
    indice_cfpt,
    indice_cfms
from _row_num
where seqid = 1