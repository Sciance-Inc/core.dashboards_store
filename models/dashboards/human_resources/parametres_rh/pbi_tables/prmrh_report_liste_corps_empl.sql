{#
Dashboards Store - Helping students, one dashboard at a time.
Copyright (C) 2023  Sciance Inc.

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
{{ config(alias="report_liste_corps_empl") }}

select
    corp_empl,
    descr_corp_empl,
    corp_empl_avec_descr,
    categorie,
    cast(date_deb as date) as date_deb,
    cast(date_fin as date) as date_fin,
    case
        when dans_paie = 1 then 'Avec paiement' else 'Sans paiement'
    end as statut_paie,
    case when is_termine = 1 then 'Expiré' else 'En vigueur' end as statut_validite,
    case
        when categorie = 'Non catégorisé' then 6 else cast(left(corp_empl, 1) as int)
    end as ordre_categorie
from {{ ref("prmrh_stg_lien_flag") }}
