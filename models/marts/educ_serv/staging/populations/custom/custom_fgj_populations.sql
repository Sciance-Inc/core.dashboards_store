{#
    Create a dummy table with no rows. Actually selecting 0 rows is required as DBT does not support no-data materializations.
    The `adapter.get_relation` pattern can only be used with seeds and not tabLe.

    This table acts as an entry point for the custom population and has to be overrided from the cssXX.data.store.
#}
{% if execute %}
    {{
        log(
            "WARN : custom_fgj_populations is NOT overrided. No custom populations will be added.",
            true,
        )
    }}
{% endif %}

with
    dummy as (
        select 'FOOBAR' as code_perm, id_eco, 2023 as annee, 'custom_1' as population
    )

select top 0 *
from dummy
