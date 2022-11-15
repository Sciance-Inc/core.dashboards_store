
# Core.store
> ETLs and Dashboards store.

* The `Configurations guidelines` are mandatory to either use or contribute to the Dashboard store.

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

* Two enable the ETL for a dashbaod, the analyst schould update it's **inherited dbt_project** to trigger the computation of the required tables. Basically the analyst has to :
  * Move the required data from the source server to the analytical one.
    * (For instance, if you want a dashboard related to geobus, you must first move the raw geobus data into the analytical server (don't forget to pseudo-anonymize the data))
  * Activate all the **sources** required by the dashboard
  * Acticate the ETL folder corresponding to the dahsboard I want to compute the data for.

* The the next section showcases the main datasources used by the dashboards.

## Dashboards depencies and datasources
> For a dashboard to be computed, the analyst must ensure that the required datasources are available in the analytical server.

### Prospectif_cdep

#### Data dependencies

* **paie**

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
  

# Contributions guidelines

**Read me first**

* Use your own schema for developmment 
* The `DEV` profile used must has the foolowing schema : `dbo_<username>` so that all your developement are going to be done on your own schema
* To ease collabotion, please, use `git flow` to manage your branch and create your features.
## Building the documentation
> You can build the DBT documentation with the following command

* Use the following code snippet to build and serve the documentation

```bash
dbt docs generate
dbt docs serve
```

## Conventions and developement guidelines

### Naming conventions

#### Table conventions
* Use _snake_case_ naming conventions.
* Use the following table prefixing conventions

| Table type | Description                                                                                                                                                                                                                                        | Prefix   | Exemple                  |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------ |
| fact       | Contains metrics describing a student                                                                                                                                                                                                              | fact_    | fact_eleve               |
| dimension  | A map between an arbitrary ID and a friendly name                                                                                                                                                                                                  | dim_     | dim_subject_category     |
| bridge     | A mapping of between-systems-primary-key or in-systems-primary-key-clustered                                                                                                                                                                       | bridge_  | NA |
| base       | A base table is a skeleton table used to build fact tables                                                                                                                                                                                         | base_    | NA   | 
| staging    | A staging table is a by product of the construction of fact table. <br>The table kind of acts as a fact table, but is not be queried by itself.<br>Staging tables are generally combined together or joined on a base table to create a fact table | stg_     | stg_droppers_raw         |
| interface     | The all mighty. Interfaces are tables mapping to the raw data from the operational system. It's basically a selected followed by a list of the fields used in the downstream tasks. Those tables can be overriden in the inherited package to map the CSS requirements.                                                                                             | target_  | target_perseverance      |