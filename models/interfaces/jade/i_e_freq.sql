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
    fiche,
    annee,
    datedeb as date_deb,
    convert(date, datedeb, 112) as date_deb_as_date,
    -- Date fin
    datefin as date_fin,
    case
        when (datefin = '' and annee = {{ core_dashboards_store.get_current_year() }})
        then getdate()  -- Prendre la date actuelle si l'année scolaire est en cours et la date est vide
        when datefin = ''
        then convert(date, concat(annee + 1, '-06-30'), 102)  -- Prendre le 30 juin de l'année scolaire si la date est vide
        else convert(date, datefin, 112)  -- Convertir la date_fin
    end as date_fin_as_date,
    statut,
    org,
    ecocen as eco_cen,
    bat,
    client,
    freq,
    prog,
    serviceenseign as service_enseign,
    typefreq as type_freq
from {{ var("database_jade") }}.dbo.e_freq
with (nolock)
