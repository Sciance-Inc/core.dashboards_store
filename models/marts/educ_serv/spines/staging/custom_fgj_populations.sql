{#
    Create a dummy table with no rows. Actually selecting 0 rows is required as DBT does not support no-data materializations.
    The `adapter.get_relation` pattern can only be used with seeds and not tabLe.

    This table acts as an entry point for the custom population and has to be overrided from the cssXX.data.tbe.
#}

{% if execute %}
{{ log('WARN : custom_fgj_populations is NOT overrided. No custom populations will be added.', true )}}
{% endif %}

WITH dummy AS (
    SELECT
        'FOOBAR' AS code_perm,
        2023 AS annee,
        'custom_1' AS population
)

SELECT TOP 0 * FROM dummy