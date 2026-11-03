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
{{ config(enabled=target.type == "fabric") }}

{% set cases = [
    ("equal_counts", "one_row", "one_row", [], 0),
    ("empty_counts", "empty_rows", "empty_rows", [], 0),
    ("different_counts", "one_row", "two_rows", [], 1),
    ("empty_left", "empty_rows", "two_rows", [], 2),
    ("empty_right", "two_rows", "empty_rows", [], 2),
    ("grouped_equal", "two_rows", "two_rows", ["id", "category"], 0),
    ("grouped_empty", "empty_rows", "empty_rows", ["id"], 0),
    ("grouped_missing", "one_row", "two_rows", ["id"], 1),
    ("grouped_empty_left", "empty_rows", "two_rows", ["id"], 2),
    ("grouped_empty_right", "two_rows", "empty_rows", ["id"], 2),
    ("grouped_different", "one_row", "two_rows", ["category"], 1),
    ("grouped_null", "null_row", "null_row", ["id", "category"], 0),
    ("grouped_disjoint", "one_row", "null_row", ["id"], 2),
] %}

with
    empty_rows as (select 1 as id, 'a' as category where 1 = 0),
    one_row as (select 1 as id, 'a' as category),
    two_rows as (
        select 1 as id, 'a' as category
        union all
        select 2 as id, 'a' as category
    ),
    null_row as (select cast(null as int) as id, 'a' as category),
    {% for name, model, compare_model, columns, expected in cases %}
        {{ name }} as (
            {{
                core_dashboards_store.fabric__test_equal_rowcount(
                    model, compare_model, columns
                )
            }}
        )
        {% if not loop.last %},{% endif %}
    {% endfor %}

{% for name, model, compare_model, columns, expected in cases %}
    select '{{ name }}' as failed_case
    from {{ name }}
    having coalesce(sum(diff_count), 0) != {{ expected }}
    {% if not loop.last %}
        union all
    {% endif %}
{% endfor %}

{{ config(fail_calc="count(*)") }}
