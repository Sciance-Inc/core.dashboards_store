
# Core.store
> ETLs and Dashboards store.

* The `Configurations guidelines` are mandatory to either use or contribute to the Dashboard store.
* Please read the `Contributing guidelines` to ... contribute to the Dashboard store.

# Configuration guidelines

## Python environement
> All the ETLs are written with **DBT** and within a ** Python Poetry** environement.

* Activate an configure the _Poetry__ environement with the following snippet and install the required dependencies


```bash
poetry shell
poetry install
```

## Configuring DBT
* You must have a valid dbt profile :

Here is a snippet demonstrating the profile to use (_you must replace the user, the schema, and the password_)

```yaml
cssxx_prodrome:
  target: dev
  outputs:
    dev:
      type: sqlserver
      driver: 'ODBC Driver 17 for SQL Server'
      server: 192.168.208.12
      port: 1433
      database: tbe_dev
      schema: dbo
      user: whoAmI
      password: "DontLookAtMeCauseImSecret"
      trust_cert: False
```

* Feel free to smoketest your connection with the awsome `dbt debug`

## Executing the ETLs
* The ETLs schould be executed **from** your **css** package/project. 
* Your **css** project schould override the configurations defined in the `dbt_project.yml` file of the **core.store** project.


# User guidelines
> How to `install` a new dashboard in my CSS ?

## How to enable a dahsboard ?

* To enable the ETL for a dahsboard, the analyst schould update it's **inherited dbt_project** to trigger the computation of the required tables. Basically the analyst has to :
  * Move the required data from the source server to the analytical one.
    * (For instance, if you want a dashboard related to geobus, you must first move the raw geobus data into the analytical server (don't forget to pseudo-anonymize the data))
  * Activate all the **sources** required by the dashboard
  * Acticate the ETL folder corresponding to the dahsboard I want to compute the data for.

* The next section showcases the main datasources used by the dashboards.

## Which dashboards are available ?
> This section provides a quick overvierw of each ones of the dashboards available in the store. Please, refers to the next section for more details about the dashboard you are interested in.

| Dashboard 	| Description 	| Owner 	|
|-----------	|-------------	|-------	|
| prospectif_cdep  |  High-level metrics to be looked at by the c-levels	| Mohamed Sadqi (CSSVDC)	| 
| transport  |  Operational dashboard. To track the financial metrics of the school board transportation system	| Maryna Zhuravlova (CSSHR)	|
| emo_conge | Monitor employees absences and leaves 	| Gabriel Thiffault (CSSVT)	|
| res_epreuves | Track the percentage of success for each one of the mandatory and optional evaluations of the schoold board | hugo juhel, Mohamed Sadqi (CSSVDC)	|
| suivi_resultats | Track the resusts of the students with a failed course | Mohamed Sadqi (CSSVDC), hugo juhel |
| emp_actif | La liste des employés actifs | (CSSSDGS) Nicolas Pham, Simon Robitaille |

## Dashboards depencies and datasources
> For a dashboard to be computed, the analyst must ensure that the required datasources are available in the analytical server.

### How to add a new dashboard to my environement ?
generally speaking, a dashboard can be added by setting the following lines in your inherited `dbt_project.yml`.

```bash
models:
  tbe:
    <dashboard name>
      +enabled: True
    shared:
      <dashboard source name>
        +enabled: True
```

where `dashboard name` and `dashboard source name` are to be adapted to the dashboard you want to enable.


Some dashbaords require you add tables very specifis to your inherited repo. Thoose tables are generally described in the `sources` / `adaptders/sources.yml` files of the dashboard you want to enable (in the core repo). You will need to use 9and adapt) the following snippet to enable the dashboard.



```bash
models:
  tbe:
    <dashboard name>
      +enabled: True
    shared:
      <dashboard source name>
        +enabled: True
  <css profile name>
    <dashboard name>
      +enabled: True
      <custom folder with specifics names> 
        +schema: <schema name as indicated in the core source>
```

> The following section describe the specific for each dashboard.


### Transport
> This dashboard shows operational data about the schoolboard transport system.

#### Data dependencies
> Thoose dependies schould be toogle on for the models to be computed.
* **Databases** :
   * geobus  #  schoolboard transport
   * piastre #  payment system for the schoolboard transport
* **Sources** :
  * *database_geobus*
* **Dashboards**  

### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file.

```yaml
models:
  tbe:
    transport: # Activate the dashboard
        +enabled: True
    shared: 
      interfaces:  # Active the geobus source
          geobus:
            +enabled: True
```

### Prospectif_cdep
* **Indicateurs** :
  * Pour l'objectif "Attirer et retenir du personnel qualifié et engagé"(C6), l'ICP équivaut au: 
    * Nb d'employés actifs sur un poste régulier dont la date actuelle - date d'entrée en poste > 2 ans / Nb employés actifs  à l'emploi régulier (toute ancienneté confondue). Employé = qui relève des services du centre administratif (hors service à l'élève direct)(ex. : TL : gens qui relèvent du 130) 
  * Pour l'objectif "Planifier la main-d'oeuvre de façon intégrée"(PI7), l'ICP équivaut au: 
    * Ratio du Nb de personnes en âge de départ (55-65 ans) à la retraite pour les postes permanents / Nb total employés permanents
  * Pour l'objectif "Développer des stratégies de fidélisation innovantes"(AI6), l'ICP équivaut au:
    * 100% - Nb de départ volontaire à partir du 1 juillet à la fin juin (ayant été actif à au moins un moment dans l'année) / Nb d'employés régulier global
  * Pour l'objectif "Diminuer l'impact financier du roulement du personnel"(F7), l'ICP équivaut au: 
    * Nb de dossier ouvert (poste existant)  * Coûts spécifiques à la dotation /  Masse salariale de l'année dernière

* **Calcul des indicateurs** :
  * Pour l'objectif "Attirer et retenir du personnel qualifié et engagé"(C6), le calcul de l'ancienneté a été calculer en additionnant le nombre de jour par période pour chaque employé. Periode = Passage de l'employé de l'état actif à inactif.
    * TODO: Filtrer seulement les employés du centre administratif
  * Pour l'objectif "Développer des stratégies de fidélisation innovantes"(AI6), le calcul de la fidélité prend en compte le nombre d'employé qui quitte volontairement entre le 1er juillet au 30 juin la CSS.
  * Pour l'objectif "Diminuer l'impact financier du roulement du personnel"(F7), l'ICP équivaut au: 
    * Nb d'employés qui ne travaillent plus au CSS par corp d'emploi  * le salaire moyen par corp d'emploi /  Masse salariale de l'année dernière
#### Data dependencies
* **Databases** :
  * paie
  * gpi
  * jade
* **Sources** :
  * *populations* : The dashboard requiers some population tables to be defined in you css-specific repository. Please, refers to `core.tbe/models/prospectif_cdep/adapters/sources.yml` to get the implementation details.
  * *employees_status* : The dashboard requiers some employees status tables to be defined in you css-specific repository. Please, refers to `core.tbe/models/prospectif_cdep/adapters/sources.yml` to get the implementation details.
* **Dashboards**  

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file.

```yaml
seeds:
    tbe:
        prospectif_cdp:
            +tags: ["prospectif_cdp"]
            +schema: 'prospectif_cdp_seeds'
            +enabled: True
  
  /* --  You must add a CSV named  'cstmrs_stat_eng.csv' file to define the permanent employees selection criterion,  with your CSS 'custom' values.  Please read 'Configuration of CSSXX cstmrs_stat_eng.sql seed file'  section.
    cssXXX_tbe:
        prospectif_cdp:
            +tags: ["prospectif_cdp"]
            +schema: 'prospectif_cdp_seeds'        

models:
  tbe: # Enable the models from the core repo
    prospectif_cdp: # Enable the prospectif_cdep
        +enabled: True
    shared:
        interfaces: # Both the paie and gpi databases are needed for this dashboard
            paie:
                +enabled: True
            gpi:
                +enabled: True
  cssXX_tbe:  # the CSSXX_TBE is the name of your inherited project.
    prospectif_cdp:
      +tags: ["prospectif_cdp"]
      populations:  # core.prospectif_cdp expects the populations to live in the prospectif_cdp_staging schema. Please refers to core/models/prospectif_cdep/adapters/sources.yml for more details about the concrete implementation you must provide the core with.
        +schema: 'prospectif_cdp_staging'
```

### Configuring the population
TODO : add the population configuration detailss

### configuration of CSSXX cstmrs_stat_eng.sql seed file 

```yaml
sources:
  - name: cstmrs_stat_eng
    description: >
      Indicators of the current state of  employee's files. using to determine retirement(empl_retraite)
      etat_stat-  etat_st- filterong for general status groups, where 1 -  on service , 2 - on vacance, 3 - inacif, finished the service.
      For mor ditals read sources.yml in the core models
    config:
      column_types:
        etat_empll: varchar(5)
        etat_discr: varchar(50)
        etat_st: int
```

### resultats_etapes
> Provides a quick overview of the results of the mandatory and optional evaluations by the school board.
  
#### Data dependencies
* **Databases** :
  * gpi
  * jade (jeunes)
* **Sources** :
  * *edo.ResultatsCompetenceEtape* : contains results of the mandatory and optional evaluations corrected by the CSS
  * *dbo.E_RI_Resultats* : contains results of the mandatory and optional evaluations corrected by the MEQ
* **Dashboards**  

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file.
> This table needs some seeds. Make sure to run `dbt seed --full-refresh` to populate the seeds.

```yaml
seeds:
    tbe:
        res_epreuves:
            +tags: ["res_epreuves"]
            +schema: 'res_epreuves_seeds'
            +enabled: True
    -- Add, if any, a CSV named `custom_subject_evaluation` with your `in-house` evaluations
    cssXXX_tbe:
        res_epreuves:
            +tags: ["res_epreuves"]
            +schema: 'res_epreuves_seeds'

models:
  tbe: # Enable the models from the core repo
    res_epreuves:
      +enabled: True
    shared:
        interfaces: # The dashboard only needs the GPI database
            gpi:
                +enabled: True
```

#### Adding a specific list of `in-house` evaluations
> This step is optional. By default, the dashboard will track the mandatory evaluations only.

* Add a CSV named `custom_subject_evaluation` here :  `cssXX/seeds/res_epreuves/custom_subject_evaluation.csv`
* Add a `schema.yml` file here : `cssXX/seeds/res_epreuves/schema.yml` (with the following content) :

```yaml
version: 2

seeds:
  - name: custom_subject_evaluation
    description: Custom mapping of the custom evaluations to their cod_matiere
    config:
      column_types:
        cod_matiere: varchar(32)
        no_competence: varchar(32)
        cod_etape: varchar(32)
        friendly_name: varchar(64)
  
 
  
 
```

Populate the `csv`, with the 4 columns. Use the `GPI.Edo.ResultatsCompetenceEtape` table to find the appropriate mapping.

### Setting a custom `threshold`
> The threshold is used to compute the identify the overachieving students. It is set to 70% by default.

You can override the default threshold by adding the following var in your `dbt_project.yml` file.

```yaml
vars:
    # res_epreuves's dashboard variables:
    res_epreuves:
        threshold: 70
```

### empl_actif
> This dashboard list the active employees of the CSS. It is used to compute the number of employees in the CSS.
  
#### Data dependencies
* **Databases** :
  * paie
* **Dashboards** 
* **Marts**
  * human_resources (seeds)

#### Deploying the dashboard
##### 1) Populating the seeds
> This dashboard requiers the specification of the seeds in the `human_resources` mart.  `cssxx_tbe/dbt_project.yml`.

The seed must be populated in `cssXX/seeds/marts/human_resources/` and as per the definition of the `core/seeds/marts/human_resources/schema.yml` mart. 

Please refer to the `human_resources` mart documentation for more details.

Do not forget to refresh your seeds with the `dbt seeds --full-refresh` command.

##### 2) Updating your `cssXX/dbt_project.yml` file
> This dashboard requiers the `paie` interfaces to be enabled. Integrate the following code to your `cssXX/dbt_project.yml` file to enable the dasboard.

```yaml
# cssXX/dbt_project.yml
models:
  tbe: # Enable the models from the core repo
    emp_actif:
      +enabled: True
    shared:
        interfaces: # ce tdb utilise seulement la paie
            paie:
                +enabled: True
```

##### 3) Smoketesting the dashboard

```bash
dbt build --select tag:emp_actif
```

#### Configuring the dashboard

##### Configuring the `nbrs_sem_dern_paie`
> The `nbrs_sem_dern_paie` variable is used as a recency parameters. It's used to filter out employeed for which the last paye occuperd for too long time. It is set to 1 by default.

The variable can be overriden by setting the `nbrs_sem_dern_paie` variable in the `dbt_project.yml` file, in the `vars` section and under the `emp_actif` key. Please consults  `core/dbt_project.yml` to find the default value and see an example of the specification of this variable.


```yaml
# cssXX/dbt_project.yml
vars:
  empt_actif:
    nbrs_sem_dern_paie: 1
```

### suivi_resultats
> Monitor the grades of students (s1 to s3) in maths and french . The dashboard displays, for each students currently enrolled in s1 to s3, the history of it's grades for all courses belonging to the same group of courses (maths or french). The dashboard conditionally renders the student status. Only the last grade for a given course code is taken into considerations.

#### TODOS
* Plug the dashboard to the yet-to-be-born populations mechanism
* Add the `reprises`
* Add the RLS mechanism

#### Data dependencies
* **Databases** :
  * gpi

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file.

```yaml
seeds: 
  tbe:
    suivi_resultats:
      +enabled: True

models: 
  tbe:
    suivi_resultats:
      +enabled: True
```

#### Overriding the default list of tracked courses
> This step is optional. By default, the dashboard will only monitor the courses listed in `tbe/seeds/suivi_resultats/tracked_courses.csv`

You can provide your own implementation of `tracked_courses`. To do so, just write a CSV file named `tracked_courses` in the `cssXX/seeds/suivi_resultats` folder and disable the default one by adding the following line in your `dbt_project.yml` file.

```yaml
seeds:
  tbe:
    suivi_resultats:
      +enabled: true
      tracked_courses:
        +enabled: False
```

__When overriding the tracked courses, you might want to override the tracked level as well.__

#### Overriding the default list of tracked levels
> This step is optional. By default, the dashboard will only monitor the students currently enrolled in the livels listed in `tbe/seeds/suivi_resultats/tracked_level.csv`

You can provide you own list of `tracked_levels`. If, for instance, you add a new tracked course in sec 4, you will want to add the level 4 to the list of tracked levels. To do so, just write a CSV file named `tracked_levels` in the `cssXX/seeds/suivi_resultats` folder and disable the default one by adding the following line in your `dbt_project.yml` file.

```yaml
seeds:
  tbe:
    suivi_resultats:
      +enabled: true
      tracked_levels:
        +enabled: False
```

To override both the tracked courses and the tracked levels, just DON'T enable the `tbe/suivi_resultats/seeds`.

### Setting a custom `cod_css`
> cod_css will be used to filter Jade table by the organisation code to exclude student belonging to other CSS

You can set it by adding the following var in your `dbt_project.yml` file.

```yaml
vars:
    # res_epreuves's dashboard variables:
    res_epreuves:
        cod_css: ###% --the first 3 digits of your organization code
```
# Contributing guidelines

**Read me first**

* Use your own schema for developmment, configured through the `dbt_project.yml` file.
to be done on your own schema
* To ease collaboration, please, use `git flow` to manage your branch and create your features. Try to rebase your branch onto `develop`.

## Building the documentation
> You can build the DBT documentation with the following command

* Use the following code snippet to build and serve the documentation

```bash
dbt docs generate
dbt docs serve
```

## Conventions and developement guidelines

### Naming, and folders structure conventions

#### Folders conventions
* All the code lives in the `models` folder.
* All the dashboards live in the `reporting` folder.
* Each subfolder of `models` should be named after the corresponding dashboard it's belongs to (one dashboard, one folder containing it's SQL code).
  * The only exceptions is the `shared` folder. that contains code to be reused accros the various dashboards.

| subfolder | Description                                                                                                                                                                                                                                        
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------ |
| adapters       | Subfolder where we specify the tables defined in the project dbt css necessary.                                                                                                                                                                                                              
| features  | sub-folder that contains all the definitions of fact tables                                                                                                                                                                                                  
| spines     | sub-folder that contains all the definitions of staging tables                                                                                                                                                                                                                                                                                                                                                        
| pbi_tables    | subfolders where we store all the tables necessary for the proper functioning of the dashboard



#### Variable conventions
* Don't use spaces in your variables names
* Please, stick to a _snake_case_ naming convention
  * Use the interface tables to set the right names for the variables.
* Reserved keywords schould be written in caps.

#### dbt_project.yaml conventions
> The `dbt_project.yaml` has to be updated every time a new dashboard is added to the store.

* Each dashboard (ie, each subfolder of the `models` folder) schould be given a *tag* and a *schema*. The following exemple shows the minimal lines to add to the `dbt_project.yaml` file to add `dummy_dashboard` to the store. The rational behind this convention is to ease filtering information in either the database or the documentation.


```yaml
models: # Already here, for reference only
  tbe: # Already here, for reference only
    +enabled: False # Already here, for reference only
    dummy: 
      +tags: ['dummy']
      +schema: 'dummy'
```
### Naming conventions
* use _snake_case_ to names your variables.

#### Table conventions
* Use _snake_case_ naming conventions.
* Use a **prefix** to indicates the high-level objective of the table. The following table prefixing conventions schould be used.

| Table type | Description                                                                                                                                                                                                                                        | Prefix   | Exemple                  |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------ |
| fact       | Contains tables of facts                                                                                                                                                                                                              | fact_    | fact_eleve               |
| dimension  | A map between an arbitrary ID and a friendly name                                                                                                                                                                                                  | dim_     | dim_subject_category     |
| bridge     | A mapping of between-systems-primarish-key                                                                                                                                                                      | bridge_  | NA |
| base       | A base table is a skeleton table used to build fact tables                                                                                                                                                                                         | base_    | NA   | 
| staging    | A staging table is a by product of the construction of fact table. <br>The table kind of acts as a fact table, but is not be queried by itself.<br>Staging tables are generally combined together or joined on a base table to create a fact table | stg_     | stg_droppers_raw         |
| interface     | The all mighty. Interfaces are tables mapping to the raw data from the operational system. It's basically a select clause followed by a list of the fields used in the downstream tasks. Those tables can be overriden in the inherited package to map the CSS requirements. Please, only add the columns you need. | target_  | target_perseverance      |
| reporting     | Reporting tabel. Used as an eaye-catcher to easily detect the tables we need to plug the dashboard on. | rprt_  | rprt_emp65_ann_bdgt      |
# How to 

## Between projects conflicting tables names
> Some tables names are quite generic (base_spine, dim_school) and can be used in various contexts without refering to the same underlying table. To avoid confusion, please, use the following pattern to disambiguate the tables.


##### Exemple
Let's consider the following two dashboards : `employees_absences` and `dummy`.
```
.
└── core.store/
    ├── reporting/
    │   └── employees_absences.pbit
    └── models/
        ├── employees_absences/
        │   └── fact_absences.sql
        └── dummy/
            └── fact_absences.sql
```

```yaml
models:
  +employees_absences:
    +schema: 'employees_absences'
    +tags: ['employees_absences']
  +dummy:
    +schema: 'dummy'
    +tags: ['dummy']    
```

The two dashboards are using a table named `fact_absences` but the SQL code is not the same, so I do need thoose two tables. Unfortunetely, DBT will raise an error as each name has to be unique.

An easy fix is to rename one of the `fact_absences` tables. Let's say we rename `modesl/dummy/fact_absences` to `dummy_fact_absences`. DBT will now be able to compile the code and any downstream task of the dummy project could refers to the table using `{{ ref('dummy_fact_absence') }}`

This issue with this fix is that DBT will output a `dummy_fact_absences` table in the `dummy` schema. This is redundant, as the conflict happens *between* schemas, and not *within* the `dummy` schema. Fortunately, we can override the outputed name in the SQL code by adding the following line into `dummy_fact_absences.sql`.

```sql
{{ config(alias='fact_absences') }}
```

#### DBT error message
In such case, DBT would output an error message similar to the following one.


```
Compilation Error
  dbt found two models with the name "<foobar>".
  
  Since these resources have the same name, dbt will be unable to find the correct resource
  when looking for ref("foobar").
  
  To fix this, change the name of one of these resources:
  - model.tbe.removeme (models/prospectif_cdp/features/foobar.sql)
  - model.tbe.removeme (models/emp_conge/feature/foobar.sql)
```

##### Pattern
> The generic pattern to solve the between-project-conflicting-tables-names issue is the following :

1. Prefix your table with the (unique) friendly name of your dashboard.
   * The friendly name schould be short. Maybe 3-to-10 letters. `dummy` could become `dmy`
2. Add a DBT directive into your table code to output the table under it's original name by setting the alias property



### RLS
  Les table utilisée:
    utilisateurs_ecoles
      tables utilisées dans la PAIE-GRH   
      . GI.Identite
    ecole
      tables utilisées dans la PAIE-GRH
      . GI.Identite
    ecole
      tables utilisées dans la PAIE-GRH
      . pai_tab_lieu_trav
    Il suffit d'appliquer ces 2 tables ci-hauts pour filter les données dans les tableaux de bords.

### emp_actif
  Les table utilisée:
    emp_actif
      tables utilisées dans la PAIE-GRH   
      . paie_dos
      . paie_dos_2
      . paie_dos_empl
      . paie_tab_corp_empl
      . pai_tab_lieu_trav
      . pai_tab_stat_eng
      . pai_tab_etat_empl
    On prend seulement
       . Emploi: principal
       . Courriel: n'est pas null
       . État: actif
       . État: pas en cessation d'emploi
       . Depuis: 2020-07-01
       . Date dernière paie: à partir de la date d'aujourd'hui moins une semaine.
    Il y a une variable: nbrs_sem_dern_paie: par défaut = 1
  c'est un rapport pour avoir tous les employés actifs.