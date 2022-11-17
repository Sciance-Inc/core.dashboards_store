
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
* Your **css** project schOuld override the configurations defined in the `dbt_project.yml` file of the **core.store** project.


# User guidelines
> How to `install` a new dashboard in my CSS ?

## How to enable a dahsbord ?

* To enable the ETL for a dashbaod, the analyst schould update it's **inherited dbt_project** to trigger the computation of the required tables. Basically the analyst has to :
  * Move the required data from the source server to the analytical one.
    * (For instance, if you want a dashboard related to geobus, you must first move the raw geobus data into the analytical server (don't forget to pseudo-anonymize the data))
  * Activate all the **sources** required by the dashboard
  * Acticate the ETL folder corresponding to the dahsboard I want to compute the data for.

* The the next section showcases the main datasources used by the dashboards.

## Which dashboards are available ?
> This section provides a quick overvierw of each ones of the dashboards available in the store. Please, refers to the next section for more details about the dashboard you are interested in.

| Dashboard 	| Description 	| Owner 	|
|-----------	|-------------	|-------	|
| prospectif_cdep  |  High-level metrics to be looked at by the c-levels	| Mohamed Sadqi (CSSVDC)	| 
| transport  |  Operational dashboard. To track the financial metrics of the school board transportation system	| Maryna Zhuravlova (CSSHR)	|
| emo_conge | Monitor employees absences and leaves 	| Gabriel Thiffault (CSSVT)	|

## Dashboards depencies and datasources
> For a dashboard to be computed, the analyst must ensure that the required datasources are available in the analytical server.

### Prospectif_cdep

#### Data dependencies
* **Sources** :
  * paie
* **Dashboards**  

### Dbt project specification

```yaml
models:
  tbe:
    prospectif_cdp: # Activate the dashbaord
        +enabled: True
  shared: 
    interfaces:  # Active the paie source
        paie:
            +enabled: True
```
  

# Contributing guidelines

**Read me first**

* Use your own schema for developmment, configured through the `dbt_project.yml` file.
to be done on your own schema
* To ease collabotion, please, use `git flow` to manage your branch and create your features. Try to rebase your branch onto `develop`.

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
* All the dasboards live in the `reporting` folder.
* Each subfolder of `models` should be named after the corresponding dashboard it's belongs to (one dashboard, one folder containing it's SQL code).
  * The only exceptions is the `shared` folder. that contains code to be reused accros the various dashboards.
  
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

#### Table conventions
* Use _snake_case_ naming conventions.
* Use a **prefix** to indicates the high-level objective of the table. The following table prefixing conventions schould be used.

| Table type | Description                                                                                                                                                                                                                                        | Prefix   | Exemple                  |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------ |
| fact       | Contains metrics describing a student                                                                                                                                                                                                              | fact_    | fact_eleve               |
| dimension  | A map between an arbitrary ID and a friendly name                                                                                                                                                                                                  | dim_     | dim_subject_category     |
| bridge     | A mapping of between-systems-primarish-key                                                                                                                                                                      | bridge_  | NA |
| base       | A base table is a skeleton table used to build fact tables                                                                                                                                                                                         | base_    | NA   | 
| staging    | A staging table is a by product of the construction of fact table. <br>The table kind of acts as a fact table, but is not be queried by itself.<br>Staging tables are generally combined together or joined on a base table to create a fact table | stg_     | stg_droppers_raw         |
| interface     | The all mighty. Interfaces are tables mapping to the raw data from the operational system. It's basically a select clause followed by a list of the fields used in the downstream tasks. Those tables can be overriden in the inherited package to map the CSS requirements. Please, only add the columns you need. | target_  | target_perseverance      |

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



