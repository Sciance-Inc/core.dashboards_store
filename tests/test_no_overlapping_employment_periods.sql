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
with
    cases as (
        select
            matr,
            ref_empl,
            cast(date_eff as date) as date_eff,
            cast(date_fin as date) as date_fin,
            is_overlap
        from
            (
                values
                    ('nested', '1', '20240101', '20240110', 0),
                    ('nested', '1', '20240102', '20240103', 1),
                    ('nested', '1', '20240104', '20240105', 1),
                    ('boundary', '1', '20240101', '20240102', 0),
                    ('boundary', '1', '20240102', '20240103', 1),
                    ('valid', '1', '20240101', '20240102', 0),
                    ('valid', '1', '20240103', '20240104', 0),
                    ('valid', '2', '20240101', '20240104', 0)
            ) as periods(matr, ref_empl, date_eff, date_fin, is_overlap)
    ),
    actual as (
        {{ core_dashboards_store.test_no_overlapping_employment_periods("cases") }}
    )

select cases.*
from cases
left join
    actual
    on cases.matr = actual.matr
    and cases.ref_empl = actual.ref_empl
    and cases.date_eff = actual.date_eff
where case when actual.date_eff is null then 0 else 1 end != cases.is_overlap
