{# 
    This table estimate the survival curves through a Kaplan-Meier estimation.
    Survival is defined as the probability of not being retired at a given age.

    About the event:
    * The Event is the time of retirement.
    * Since some people retire in an other CSS, I only consider the retirement of thoose who retire in the CSS.

    About the censure :
    * The time-of-censure is computed, FOR NON-RETIRED EMPLOYEES ONLY as the age the employee had as the time of his last pay.
    * Every employee that is not retired (quitter, vacation, payed leaves) is considered censored at the time of his last pay.

    About the univers :
    * Some employees will work AFTER they have retired (what a frightening world we live in). 
    Since I can't know their status for sure, employees first employed after they have reached the honorable age of 60 years old (or about 6 time the average live span of a duck) are removed from the dataset and aren't not considered survivors.
#}


-- Remove the employees assumed (see `about the univers`) to have take their retirement in an other CSS : thoose who start working in the CSS after they have reached 60 years old.
WITH pai_dos_expurged AS (
    SELECT 
        matr,
        date_nais,
        date_dern_paie
    FROM {{ ref('i_pai_dos') }} AS src
    WHERE DATEDIFF(year, date_nais, date_entr) < 60
)
-- Get the age the individual was censured: the age the employee had when he got his last pay.
, censored_age_matr AS (
    SELECT 
        dos.matr,
        DATEDIFF(year, dos.date_nais, dos.date_dern_paie) AS censure_age -- The age at which the individual was censured 
    FROM pai_dos_expurged AS dos
    LEFT JOIN {{ ref('fact_retirement') }} AS ret
    ON dos.matr = ret.matr
    WHERE 
        ret.matr IS NULL AND -- Only keep thoose of the employes who are NOT retired
        DATEDIFF(year, dos.date_nais, dos.date_dern_paie) BETWEEN 50 AND 70 -- Only keep thoose who are between 50 and 70 years old as the Kaplan-Meier estimation will be fitted on this date range.


-- Compute the censure table : the number of censures per age
), censored_age_table AS (
    SELECT 
        censure_age AS age, -- is actually censured_age - 1 (since I take the last seen date, and not the age the censure actually occurs at.)
        COUNT(*) AS n_censored
    FROM censored_age_matr
    GROUP BY censure_age

-- Compute the event table : the number of events (retirements) per age
), event_age_table AS (
    SELECT 
        src.age,
        COUNT(*) AS n_events
    FROM (
        SELECT 
            -- Lower and upper bound the retirement to some reasonable values.
            CASE 
                WHEN retirement_age < 50 THEN 50
                WHEN retirement_age > 70 THEN 70
                ELSE retirement_age 
            END AS age
        FROM {{ ref('fact_retirement') }}
    ) As src 
    GROUP BY age

-- Combine the event and censored table
-- TODO : add support for the no-death case and the propagation of censored data
), events_and_censored_table AS (
SELECT 
    src.age AS age,
    COALESCE(evt.n_events, 0) AS n_events,
    COALESCE(cns.n_censored, 0) AS n_censored
FROM (SELECT seq_value AS age FROM {{ ref('int_sequence_0_to_1000') }} WHERE seq_value BETWEEN 50 AND 70) AS src
LEFT JOIN censored_age_table AS cns
ON src.age = cns.age
LEFT JOIN event_age_table AS evt
ON src.age = evt.age

-- Compute the numbver of survivors for every given age
), survivors AS (
SELECT 
    age,
    n_events,
    n_censored,
    SUM(n_events + n_censored) OVER () - COALESCE(SUM(n_events + n_censored) OVER (ORDER BY age ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS n_survivors
FROM events_and_censored_table

-- Compute the instantaneous death rate
), death_rate AS (
SELECT 
    age,
    n_events,
    n_censored,
    n_survivors,
    CAST(n_survivors - n_events AS FLOAT) / n_survivors AS instantaneous_survival_rate
FROM survivors
)

-- Compute the product-limit estimator
SELECT 
    age,
    n_events,
    n_censored,
    n_survivors,
    1 - instantaneous_survival_rate AS instantaneous_death_rate,
    EXP(SUM(LOG(instantaneous_survival_rate)) OVER (ORDER BY age ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)) AS survival_rate
FROM death_rate

