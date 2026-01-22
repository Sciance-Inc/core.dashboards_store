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
    agg_ele as (
        select
            lieu_jumele,
            annee,
            count(fiche) as nb_totaux_eleve,
            sum(is_difficulte) as nb_difficulte,
            sum(is_pi) as nb_pi
        from {{ ref("eff_fact_eleve_fgj") }}
        group by lieu_jumele, annee
    ),

    nrm as (
        select
            lieu_jumele,
            annee,
            -- metrics
            nb_totaux_eleve,
            (nb_difficulte * 1.0) / (nb_totaux_eleve * 1.0) as prop_difficulte,
            (nb_pi * 1.0) / (nb_totaux_eleve * 1.0) as prop_pi
        from agg_ele
    ),

    stats as (
        select
            avg(cast(nb_totaux_eleve as float)) as mean_tot,
            stdev(cast(nb_totaux_eleve as float)) as sd_tot,
            avg(cast(prop_difficulte as float)) as mean_diff,
            stdev(cast(prop_difficulte as float)) as sd_diff,
            avg(cast(prop_pi as float)) as mean_pi,
            stdev(cast(prop_pi as float)) as sd_pi
        from nrm
    ),

    -- Standardized the raw data table
    zs as (
        select
            rd.lieu_jumele,
            rd.annee,
            /* Z-scores (standardisation) */
            (cast(rd.nb_totaux_eleve as float) - s.mean_tot)
            / nullif(s.sd_tot, 0.0) as z_totaux_eleve,
            (cast(rd.prop_difficulte as float) - s.mean_diff)
            / nullif(s.sd_diff, 0.0) as z_difficulte,
            (cast(rd.prop_pi as float) - s.mean_pi) / nullif(s.sd_pi, 0.0) as z_pi
        from nrm as rd
        cross join stats as s
    ),

    -- Adding the weight from the PCA's first axis
    w as (
        select
            cast(w_totaux_eleve as float) as w_totaux_eleve,
            cast(w_nb_difficulte as float) as w_difficulte,
            cast(w_pi as float) as w_pi
        from {{ ref("eff_coefficients_premier_axes") }}
    )

-- La notion de lieu_jumele n'existe pas dans la paie
select
    z.lieu_jumele,
    z.annee,
    -- Z metrics
    z.z_totaux_eleve,
    z.z_difficulte,
    z.z_pi,
    -- First PCA loading N(100, 15)
    cast(
        15 * (
            z.z_totaux_eleve * w.w_totaux_eleve
            + z.z_difficulte * w.w_difficulte
            + z.z_pi * w.w_pi
        )
        + 100 as int
    ) as cohort_difficulty_score
from zs as z
cross join w as w
