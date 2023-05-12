
# Core.store
> Helping students, one dashboard at a time.

## README's readme : read-it before anythinge else

* The `Configurations guidelines` are mandatory to contribute to the Dashboards store.
* Please read the `Contributing guidelines` to ... contribute to the Dashboards store.

**Disclaimer** 
This `README` is not an exhaustive documentation of the various techs underlying the store. The `README` aims at providing general information and assumes the reader has already some common knowledge about computers, computer science and business intelligence. Stuffs like environement variables, terminals, parsing, YAML, SQL, execution plans, indexes, syntax, KPI, relational-algebra, copy-pasting-from-stack overflow (the hallmark of great programmers) are out of this readme scope and assumed to be already known. A list of usefull-ish documentation links is provided as a reference in the next section to help the reader getting started. The reader is encourage to google-up the things he doesn't get a good grasp of, and add them to the documentation \o/.


## Table Of Contents

* [How to find informations in the Readme ?](#finding-missing-informations-from-the-readme)
* [Configuring my computer and repos](#configuration-guidelines)
* [How to DEPLOY an existing dashboard ?](#integrator-guidelines)
* [Which dashboard are available ?](#available-dashboards)
* [How to CREATE a new dashboard ?](#conventions-and-developement-guidelines)


## Finding missing informations from the README
> The store uses a lot of technologies such as DBT, SQL, YAML and the likes. As it would be quite cumberstome to document EVERYTHING about ANYTHING, the reader schould first look for missing information in the following links, each one being a technlogy used as a building block of the store.

* __DBT__ [a tool to run and orchestrate data transformations](https://docs.getdbt.com/docs/introduction)
* __GIT__ [because even if not everyone is building a kernel, a version-manager always comes in handy](https://git-scm.com/)
* __Ubuntu__ [Some good stuffs might come for free ;) ](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview)
* __yaml__ [A human-readable data-serialization language. Like JSON but worst.](https://circleci.com/blog/what-is-yaml-a-beginner-s-guide/?psafe_param=1&utm_source=google&utm_medium=sem&utm_campaign=sem-google-dg--uscan-en-dsa-tROAS-auth-brand&utm_term=g_-_c__dsa_&utm_content=&gclid=CjwKCAjwrpOiBhBVEiwA_473dK-ujEm1G7ONji2IsFzoHdn8liN3nCBMiTl9oL1qPxf759sXoEqdWRoCe-sQAvD_BwE)
* __SQL__ [Structured Query Language. The language used to query the database.](https://www.sqlservertutorial.net/)
* __Python__ [DBT is built in Python, you might want to have a look at it.](https://docs.python.org/3.10/)
* __Poetry__ [but let's face the truth... PIP is garbage. So we ditched it for Poetry](https://python-poetry.org/)

## How to find informations missing from both the README AND the links above ?

* [Desperate times call for desperates measures (but be carefull it's a dangerous place out there).](https://www.google.com/)
  
How to google-up stuff ?
* Ask questions in human language
* Use word like `how to`, `what is`, `why`, `when`, `where` to start your question with :
  * "How to solve a git conflict in VSCODE and Azure DevOps ?" 
  * "Where to store the `dbt_project.yml` file ?"
  * "What is Google used for ?"
* Ask for differences and comparisons : 
  * "How are related `dbt's seeds` to `dbt's models`"
  * "What is the difference between a `dbt_project.yml` and a `profiles.yml`"
* Use the `site:` syntax to restrict your search to a specific website.
  * "What is dbt cloud site:https://stackoverflow.com/"
* Quote the words / sentences "<my keyword or error message>" to look for the exact match. 
  * It's really usefull to search for error messages.

Be brave, try, fail and repeat ! The answer is waiting for you, somewhere out there. May the All-Mighty First-Page-Of-Google always be in your favor !

## How to navigate through the README
The `readme` is organized as follow :
* A first section is to be read by everyone, integrators and contributors, thoose of us crazy enough to want to RUN the ETLs or work-on !
* A second section is intended for the **integrators** : thoose who deploy the store in their own CSS.
* A third section is targeting the **contributors** : thoose who want to create new dashboards and fight thoose pesky bugs we all stumble on sometimes. That's the heavy stuff ! Sit tight if you go there.
* Finally a FAQ is available at the end of the document.

> Shall we spin that wheel ? : 
> * [No one will ear me scream. Let's configure my machine anyway.](#configuration-guidelines)
> * [I'm an integrator, let's deploy stuff !](#integrator-guidelines)
> * [I'm a developper, "This entire code must be purged !"](#developer-guidelines)
# Configuration guidelines
> AKA : "The heck is a profiles.yml ? "

## A tale of two repos

> Once upon a time, in the CdeP, a little `core.data.tbe` repo was born. The repo tried very hard to provide ETLs for all the CSS belonging to the CdeP. But the CSS were many and the SQL capabilites to retrofit itself to the CSS's context were few. So the `core.data.tbe` repo decided to split itself into many little repos, one for each CSS.And the `cssXX.data.tbe` repo was born. And the `cssXX.data.tbe` repo was granted the power to override anything from `core.data.tbe`. And the `core.data.tbe` repo was happy. And the `cssXX.data.tbe` repo was happy. And the CdeP was happy. And they all merged develop into master happily ever after. 

The moral of the story is that the `core.data.tbe` repo is the parent repo of all the `cssXX.data.tbe` repos. The `core.data.tbe` repo contains all the ETLs that are common to all the CSS. The `cssXX.data.tbe` repo contains all the ETLs' code that are specific to the CSS XX. I you have already been exposed to some Object-Oriented Programing, the `core.data.tbe` repo is the parent class and the `cssXX.data.tbe` repo is the child class. Yes, that's that simple.

Hence every CSS will end WITH TWO REPOS : 
* `core.data.tbe` : the parent repo providing sensitive default for all CSS
* `cssXX.data.tbe` : the child repo containing the ETLs specifics to the CSS XX
  * `XX` schould be replaced with the friendly name of your CSS (ex: cssdgs.data.tbe for Des-Grandes-Seigneuries)

Thoose two repos are to be cloned in the same directory, the `<working directory>` of your choice. It's actually not mandatory but the `README` expects to do so..

## What you must have already configured by now 
>By convention : 
> * `<foobar>` defines a a placeholder to be replaced. `foobar` is usually pretty self  explanatory and defines the concept to replace the palceholder with.
> * `<working_directory>` is a placeholder to be replaced with the name of the directory containing your two repos.


We assume the reader as already set-up :
* A working computer from the last decade (or a Potato (a Minitel won't work) connected to internet with a screen and a keyboard)
* A working environement with `Python`, `Pyodbc`, `Poetry`, `wsl2` as per the wiki
* The two repositories `core.data.tbe` and `cssXX.data.tbe` cloned on his computer in the `<working directory>` of his choice. 
  * The *Tale of two repos* explains why you need two repos : the core is common, the child is specific to your CSS. If you haven't read it yet, do-it ! It's a nice bedtime story.


## Python environement
> All the ETLs are written with **DBT** and within a **Python Poetry** environement.

* Activate an configure the _Poetry_ environement with the following snippet and install the required dependencies

```bash
cd <working_directory>/core.data.tbe
poetry shell
poetry install
```
## Configuring DBT
* You must have a valid dbt profile WITH THE SAME NAME AS THE ONE USED IN your `<cssXX.data.tbe>dbt_project.yml` file.

Here is a snippet of a profile to use (all placeholders schould be replaced).

```yaml
cssxx_tbe:
  target: dev
  outputs:
    dev:
      type: sqlserver
      driver: 'ODBC Driver 17 for SQL Server'
      server: <your server's IP >
      port: <your server's port>
      database: <the database to store the ETLs results into> # Schould be tbe_dev
      schema: <your name> # Lowercase, not spaces of any sort
      user: <The username to use to connect to the DB>
      password: <The password associated to the user you are connecting to>
      trust_cert: True
```

* Feel free to smoketest your connection with the awsome `dbt debug`

## Executing the ETLs
> Never-ever execute an ETL from the core. That won't work and you will be sad.
> The ETLs schould be executed **from** your **css** package/project. 

**Why schould ETLs being executed from your CSS repo ?**
Remember the *Tale of Two Repos* and how little `cssXX.data.tbe` was granted the right to override everything ? Well that's it ! Since you are executing the ETLs from `cssXX.data.tbe` what you are overriding in your CSS WILL HAVE PRIORITY OVER what is defined in `core.data.tbe` **Including what you are defining in `<working_directory>/cssXX.data.tbe/dbt_project.yml`**. That's the magic of the `dbt_project.yml` file.

Let's get wild and run the ETL, with the following snippet :

```bash
cd <working_directory>/cssXX.data.tbe
dbt build --full-refresh
```

*Feel free to read more about the various DBT commands from the DBT website*

# Integrator guidelines
> How to `install` a new dashboard in my CSS ?

## How to enable a dahsboard ?

### `cssXX.data.tbe/project.yml`
> It's mandatory.

* To enable the ETL for a dahsboard, the integrator schould MINIMALY update it's `cssXX.data.tbe/project.yml` to trigger the computation of the tables underlying the dashboard the integrator wants to ... integrate.
* To enable a dashboard, the integrator schould set the `enabled` flag to `true` in the `dashboards` section of the `cssXX.data.tbe/project.yml` file.

```yaml
# cssXX.data.tbe/project.yml
models:
  tbe:
    <name of the dashboard to deploy>:
      +enabled: True
```

### Interfaces
> Every time you use a NEW datasource, interfaces schould be configured.
* An ETL transforms crude data into... more data.
* The dashboard might need NEW raw data to be transformed.
* ETLs won't run well if there is no data for them to transform.
* In the `store`, raw datas are accessed through `interfaces`.
* By default, interfaces expects data to be exposed through *linked server*. If your CSS doesn't expose it's data through linked server, you will have to override the interfaces, in your `cssXX.data.tbe` repo.
* Interfaces are implemented in the `core.data.tbe` as a basic `SELECT * FROM my_table`.
* Interfaces have for sole purpose to be overrided to fit the way your CSS exposes it's data.


If you are lucky enough to work for a CSS that uses link server, you will just have to toogle the `enabled` flag to `true` in the `interfaces` section of your `cssXX.data.tbe/project.yml` file.

**How to enable an interface if you are on the lucky side**
Just toogle the `+enabled: True` flag in your `cssXX.data.tbe/project.yml` file.

```yaml
# cssXX.data.tbe/project.yml
models:
  tbe:
    shared: 
      interfaces:  # Active the geobus source
          <name of your interface>:
            +enabled: True
```

**How to enable an interface if you are a black cat !**
If you are short on luck, and work for a CSS that doesn't use linked server, you will have to override the interfaces in your `cssXX.data.tbe` repo to implement the connection logic to your data sources. But every cloud has a silver lining (yes, even Azure's Cloud) : if you are working on Azure, rest and breathe, we already have the heavy lifting done for you. You will just have to configure the interfaces to use the `Azure SQL external materialization` macro.

Otherwise, you might relay on tools like `Airbyte` to move the data arounds. Keep me posted, I'm curious !

## So we are just throwing around a bunch of `+enabled: True` ? Really ?
> "This is the way !" - The Mandatalorian.

The following snippet schould be enough to enable a dashboard and it's interfaces.
The placeholder `<dashboard name>` schould be replaced by the name of the dashboard you want to enable and the placeholder `<dashboard source name>` schould be replaced by the name of the data source the dashboard depends on.

```yaml
# cssXX.data.tbe/project.yml
models:
  tbe:
    dashboards:
      <dashboard name>
        +enabled: True
    interfaces:
      <dashboard data source name>
        +enabled: True
```

### "One does not simply enable a dashboard"
Some dashboards might need extra configuration to be provided through `seeds`. It's a frightening concept, but keep in mind that a `seed` is JUST a `.csv` file you can populate with `Excel` and save into `cssXX.data.tbe/seeds/<dashboard name>`.

*Please refer to the awsome and always up-to-date dbt documentation to learn about the `Seeds`.*

## Available dashboards
> Show me the money ! Which dashboards are available ?

> This section provides a quick overvierw of each ones of the dashboards available in the store. Please, refers to the next section for more details about the dashboard you are interested in. 

**Click on a dashboard's name to go to it's section.**

| Dashboard 	| Description 	| Owner 	|
|-----------	|-------------	|-------	|
| [prospectif_cdep](#prospectif_cdep)  |  High-level metrics to be looked at by the c-levels	| Mohamed Sadqi (CSSVDC)	| 
| [transport](#transport)  |  Operational dashboard. To track the financial metrics of the school board transportation system	| Maryna Zhuravlova (CSSHR)	|
| [emp_conge](#emp_conge) | Monitor employees absences and leaves 	| Gabriel Thiffault (CSSVT), Frédéryk Busque (CSSVT) |
| [res_epreuves](#res_epreuves) | Track the percentage of success for each one of the mandatory and optional evaluations of the schoold board | Hugo Juhel (ext), Mohamed Sadqi (CSSVDC)	|
| [suivi_resultats](#suivi_resultats) | Track the results of the students with a failed course | Mohamed Sadqi (CSSVDC), Hugo Juhel (ext) |
| [emp_actif](#empl_actif) | List all employees currently enroled in the CSS | (CSSSDGS) Nicolas Pham |


> The following section describe the specific for each dashboard. Bear with me, we are gonna drill down into the specifics of each dashboard ! Stay focused ! In each of the following section, you will learn how to tame a specific dashboard.

### Transport
> Get operational data about the Transport system of the school board. KPI include the number of circuits per parcours.

| Interfaces  | Marts 	| Marts seeds | Dashboard seeds | Additional config |
|-----------	|-------------	|-------	|-------	| -------	|
| geobus   |  No | No 	| No 	| No 	|

### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file.

```yaml
models:
  tbe:
    dashboards:
      transport: # Activate the dashboard
          +enabled: True
    interfaces:  # Active the geobus source
        geobus:
          +enabled: True
```

### Prospectif_cdep
> DEPRECATED. This section is not up-to-date and has to be rewritted. 
> START OF DEPRECATION >>>
* **Indicateurs** :
  * Pour l'objectif "Attirer et retenir du personnel qualifié et engagé"(C6), l'ICP équivaut au: 
    * Nb d'employés actifs sur un poste régulier dont la date actuelle - date d'entrée en poste > 2 ans / Nb employés actifs  à l'emploi régulier (toute ancienneté confondue). Employé = qui relève des services du centre administratif (hors service à l'élève direct)(ex. : TL : gens qui relèvent du 130) 
  * Pour l'objectif "Planifier la main-d'oeuvre de façon intégrée"(PI7), l'ICP équivaut au: 
    * Ratio du Nb de personnes en âge de départ (55 ans et plus) à la retraite pour les postes permanents / Nb total employés permanents
  * Pour l'objectif "Développer des stratégies de fidélisation innovantes"(AI6), l'ICP équivaut au:
    * 100% - Nb de départ volontaire à partir du 1 juillet à la fin juin (ayant été actif à au moins un moment dans l'année) / Nb d'employés régulier global
  * Pour l'objectif "Diminuer l'impact financier du roulement du personnel"(F7), l'ICP équivaut au: 
    * Nb de dossier ouvert (poste existant)  * Coûts spécifiques à la dotation /  Masse salariale de l'année dernièreNo

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
#### Configuring the population

#### configuration of CSSXX cstmrs_stat_eng.sql seed file 

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
> \>\>\> END OF DEPRECATION

### res_epreuves
> Provides a quick overview of the results of the mandatory and optional evaluations by the school board.

| Interfaces  | Marts 	| Marts seeds | Dashboard seeds | Additional config |
|-----------	|-------------	|-------	|-------	| -------	|
| gpi |  No | No 	| Yes 	| Yes 	|

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file with the following snippet.

```yaml
models:
  tbe: # Enable the models from the core repo
    res_epreuves:
      +enabled: True
    shared:
        interfaces: # The dashboard only needs the GPI database
            gpi:
                +enabled: True
```  

#### Additional configuration
> These steps are optional.
##### Customizing the tracked courses
> Update your `cssxx_tbe/dbt_project.yml` file.
> This table needs some seeds. Make sure to run `dbt seed --full-refresh` to populate the seeds.

* To add a list of in-house courses to be tracked :
  1. Add a `.csv` file in your `cssxx_tbe/seeds/res_epreuves` folder. The file must be named `custom_subject_evaluation.csv`. The file must be populated with the colums described in `core.data.tbe/seeds/res_epreuves/schema.yml` (refers to the `custom_subject_evaluation` seed). You might want to use the `GPI.Edo.ResultatsCompetenceEtape` table to find the appropriate mapping.

  2. Trigger a refresh of your seeds 

```bash
dbt seed --full-refresh
```

##### Setting a custom `threshold`
> The threshold is used to compute the identify the overachieving students. It is set to 70% by default.

You can override the default threshold by adding the following variable in your `dbt_project.yml` file.

```yaml
# cssxx_tbe/dbt_project.yml
vars:
    # res_epreuves's dashboard variables:
    res_epreuves:
        threshold: 70
```

### empl_actif
> This dashboard list the active employees of the CSS. It is used to compute the number of employees in the CSS.
  
| Interfaces  | Marts 	| Marts seeds | Dashboard seeds | Additional config |
|-----------	|-------------	|-------	|-------	| -------	|
| paie |  No | human_resources 	| No 	| Yes 	|

> This dashboard requiers the specification of a seed.

##### Populating the marts seed
> This dashboard requiers the specification of the seeds in the `human_resources` mart.  

The seed must be populated in `cssXX.data.tbe/seeds/marts/human_resources/` and as per the definition of the `core.data.tbe/seeds/marts/human_resources/schema.yml` mart. 

Please refer to the `core.data.tbe/seeds/marts/human_resources/schema.yml` mart documentation to get the concrete implementation.

Do not forget to refresh your seeds with the `dbt seeds --select tag:human_resources --full-refresh` command.

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file with the following snippet.

```yaml
# cssXX/dbt_project.yml
models:
  tbe: #
    dashboards:
      emp_actif:
        +enabled: True #  Enable the models from the core repo
      interfaces: # Enable the paie interface
          paie:
              +enabled: True
```

#### Additional configuration
> These steps are optional.
##### Configuring the `nbrs_sem_dern_paie`
> The `nbrs_sem_dern_paie` variable is used as a recency parameters. It's used to filter out employeed for which the last paye occuperd for too long time. It is set to 1 by default.

The variable can be overriden by setting the `nbrs_sem_dern_paie` variable in the `dbt_project.yml` file, in the `vars` section and under the `emp_actif` key. Please consults  `core.data.tbe/dbt_project.yml` to find the default value and see an example of the specification of this variable. 

```yaml
# cssXX/dbt_project.yml
vars:
  emp_actif:
    nbrs_sem_dern_paie: 1
```

##### Using the Report builder: empl_actif.rdl
> An SSRS report is available to export the list of active employees of the CSS. The `emp_actif.rdl` can be found in a `core.data.tbe/reporting/emp_actif/emp_actif.rdl`


### suivi_resultats
> Monitor the grades of students (s1 to s3) in maths and french . The dashboard displays, for each students currently enrolled in s1 to s3, the history of it's grades for all courses belonging to the same group of courses (maths or french). The dashboard conditionally renders the student status. Only the last grade for a given course code is taken into considerations.

| Interfaces  | Marts 	| Marts seeds | Dashboard seeds | Additional config |
|-----------	|-------------	|-------	|-------	| -------	|
| gpi |  No | No 	| No 	| Yes 	|

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file with the following snippet and add the `cod_css` variable.

1. Enabling the models
```yaml
#cssXX.data.dbe/dbt_project.yml
models: 
  tbe:
    dashboards: 
      suivi_resultats:
        +enabled: True
    interfaces:
      gp:
        +enabled: True
```

2. Setting a custom `cod_css`
> cod_css will be used to filter Jade table by the organisation code to exclude student belonging to other CSS. This variable MUST be set for the dashboard to work.

```yaml
#cssXX.data.dbe/dbt_project.yml
vars:
    # res_epreuves's dashboard variables:
    res_epreuves:
        cod_css: ###% --the first 3 digits of your organization code
```

#### Additional configuration
> These steps are optional. 

##### Overriding the default list of tracked courses
> By default, the dashboard will only monitor the courses listed in `core.data.tbe/seeds/dashboard/suivi_resultats/tracked_courses.csv`

You can provide your own implementation of `tracked_courses`. To do so :
1. Write a CSV file named `tracked_courses` in the `cssXX.data.dbe/seeds/dashboards/suivi_resultats` folder populated as per the `core.data.tbe/seeds/dashboards/suivi_resultats/schema.yml`'s definition.
2. Disable the default seed by using the the following snippet in your `dbt_project.yml` file : 

```yaml
#cssXX.data.dbe/dbt_project.yml
seeds:
  tbe:
    dashboards:
      suivi_resultats:
        tracked_courses:
          +enabled: False
```

__When overriding the tracked courses, you might want to override the tracked level as well.__

##### Overriding the default list of tracked levels
> This step is optional. By default, the dashboard will only monitor the students currently enrolled in the livels listed in `core.data.tbe/seeds/dashboards/suivi_resultats/tracked_level.csv`

You can provide you own list of `tracked_levels`. If, for instance, you add a new tracked course in sec 4, you will want to add the level 4 to the list of tracked levels. To do so, just write a CSV file named `tracked_levels` in the `cssXX/seeds/dashboards/suivi_resultats` folder and disable the default one by adding the following line in your `dbt_project.yml` file.

```yaml
seeds:
  tbe:
    dashboards:
      suivi_resultats:
        tracked_levels:
          +enabled: False
```

### Emp_conge
> Monitor the leaves of each employee for each related state during a specified timeline. The dashboard display the total amount of each state in each workplace, the total amount of a specific state overall and a historic of each state. 

| Interfaces  | Marts 	| Marts seeds | Dashboard seeds | Additional config |
|-----------	|-------------	|-------	|-------	| -------	|
| paie |  No | human_resources 	| No 	| No 	|

> This dashboard requiers the specification of a seed.

##### Populating the marts seed
> This dashboard requiers the specification of the seeds in the `human_resources` mart.  

The seed must be populated in `cssXX.data.tbe/seeds/marts/human_resources/` and as per the definition of the `core.data.tbe/seeds/marts/human_resources/schema.yml` mart. 

Please refer to the `core.data.tbe/seeds/marts/human_resources/schema.yml` mart documentation to get the concrete implementation.

Do not forget to refresh your seeds with the `dbt seeds --select tag:human_resources --full-refresh` command.

#### Dbt project specification
> Update your `cssxx_tbe/dbt_project.yml` file with the following snippet

```yaml
# cssXX.data.tbe/dbt_project.yml
models: 
  tbe:
    dashboards:
      emp_conge:
        +enabled: true
    interfaces:
      paie:
        +enabled: true
```
# Developer guidelines

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

| subfolder  | Description                                                                                    |
| ---------- | ---------------------------------------------------------------------------------------------- |  |  |
| adapters   | Subfolder where we specify the tables defined in the project dbt css necessary.                |
| features   | sub-folder that contains all the definitions of fact tables                                    |
| spines     | sub-folder that contains all the definitions of staging tables                                 |
| pbi_tables | subfolders where we store all the tables necessary for the proper functioning of the dashboard |



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

| Table type | Description                                                                                                                                                                                                                                                                                                         | Prefix  | Exemple              |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | -------------------- |
| fact       | Contains tables of facts                                                                                                                                                                                                                                                                                            | fact_   | fact_eleve           |
| dimension  | A map between an arbitrary ID and a friendly name                                                                                                                                                                                                                                                                   | dim_    | dim_subject_category |
| bridge     | A mapping of between-systems-primarish-key                                                                                                                                                                                                                                                                          | bridge_ | NA                   |
| base       | A base table is a skeleton table used to build fact tables                                                                                                                                                                                                                                                          | base_   | NA                   |
| staging    | A staging table is a by product of the construction of fact table. <br>The table kind of acts as a fact table, but is not be queried by itself.<br>Staging tables are generally combined together or joined on a base table to create a fact table                                                                  | stg_    | stg_droppers_raw     |
| interface  | The all mighty. Interfaces are tables mapping to the raw data from the operational system. It's basically a select clause followed by a list of the fields used in the downstream tasks. Those tables can be overriden in the inherited package to map the CSS requirements. Please, only add the columns you need. | target_ | target_perseverance  |
| reporting  | Reporting tabel. Used as an eaye-catcher to easily detect the tables we need to plug the dashboard on.                                                                                                                                                                                                              | rprt_   | rprt_emp65_ann_bdgt  |
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

