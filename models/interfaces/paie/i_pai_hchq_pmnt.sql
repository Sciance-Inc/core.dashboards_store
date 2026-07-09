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
select
    matr,
    no_cheq,
    code_pmnt,
    ref_empl,
    corp_empl,
    cast(date_deb as date) as date_deb,
    cast(date_fin as date) as date_fin,
    nb_unit,
    mnt_unit,
    mnt,
    lieu_trav,
    nb_heur_cont,
    nb_heur_auto,
    nb_heur_piec,
    cast(date_cheq as date) as date_cheq,
    code_prov as code_provenance,
    mode as mode_paiement,
    no_type_pmnt,
    no_seq
from {{ var("database_paie") }}.dbo.pai_hchq_pmnt
with (nolock)
