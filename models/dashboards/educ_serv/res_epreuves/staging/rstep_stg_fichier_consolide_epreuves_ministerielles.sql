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
{#
    The dashboards needs manually extracted data from the ministery to be complete.
    As the operation might be cumbersome, the store adopts a defensive approache and does not requiers it. The seed is implemented as an optional seed.
    To avoid requiering manual disabling from the client, the store will try to fetch the seed and just return an empty table if it does not exists.    
#}
-- # TODO : properly set the data types. Must be done when the seed file will be
-- documented
{% if execute %}
    {%- set source_relation = adapter.get_relation(
        database=target.database,
        schema=target.schema + "_res_epreuves_seeds",
        identifier="fichier_consolide_epreuves_ministerielles",
    ) -%}
    {% set table_exists = source_relation is not none %}

    {% if table_exists %}
        {{
            log(
                "The seed '*_res_epreuves_seeds.fichier_consolide_epreuves_ministerielles' DOES EXIST. The dashboard will display the results from this seed. Yé.",
                true,
            )
        }}
        select
            annee,
            sesn,
            cd_cours,
            reg_adm,
            res_ens,
            cd_orgns_resp,
            cd_orgns2,
            no_group_eleve,
            eleve_note,
            moyen_neb,
            pct_reust_neb,
            moyen_nem,
            pct_reust_nem,
            moyen_nmb,
            pct_reust_nmb,
            moyen_nmc,
            pct_reust_nmc,
            moyen_rf,
            pct_reust_rf
        from {{ source_relation }}

    {% else %}
        {{
            log(
                "The seed '*_res_epreuves_seeds.fichier_consolide_epreuves_ministerielles' DOES NOT exists. The dashboard will output INCOMPLETE results, as the comparison between your CSS's results and the province's results won't be available. You might want to have a look at the documentation to add the data from Charlemage ! ",
                true,
            )
        }}
        select
            cast(null as varchar) as annee,
            cast(null as varchar) as sesn,
            cast(null as varchar) as cd_cours,
            cast(null as varchar) as reg_adm,
            cast(null as varchar) as res_ens,
            cast(null as varchar) as cd_orgns_resp,
            cast(null as varchar) as cd_orgns2,
            cast(null as varchar) as no_group_eleve,
            cast(null as float) as eleve_note,
            cast(null as float) as moyen_neb,
            cast(null as float) as pct_reust_neb,
            cast(null as float) as moyen_nem,
            cast(null as float) as pct_reust_nem,
            cast(null as float) as moyen_nmb,
            cast(null as float) as pct_reust_nmb,
            cast(null as float) as moyen_nmc,
            cast(null as float) as pct_reust_nmc,
            cast(null as float) as moyen_rf,
            cast(null as float) as pct_reust_rf

    {% endif %}
{% endif %}
