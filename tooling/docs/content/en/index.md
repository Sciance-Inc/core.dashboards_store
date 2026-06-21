---
title: Home
navigation: True
layout: page
main:
  fluid: false
---

:ellipsis{right=0px width=75% blur=150px}

::block-hero
---
home: true
cta:
  - Get started
  - /en/introduction/introduction
secondary:
  - Open on GitHub →
  - https://github.com/Sciance-Inc/core.dashboards_store
---

#title
The shared dashboard platform for Quebec's school service centre network.

#description
A shared library of dashboards for Quebec's school service centres. Write SQL in [dbt](https://docs.getdbt.com/), get a containerized ETL with [Docker](https://www.docker.com/), and leverage your data warehouse with [Power BI](https://powerbi.microsoft.com/).

#extra
  ::list
  - **10+ dashboards** ready to use
  - Sensible defaults provided out of the box
  - Fully configurable **dashboards** and **SQL scripts**
  ::

#support
  ::terminal
  ---
  content:
  - git clone git@github.com:Sciance-Inc/core.dashboards_store.git
  - cd core.dashboards_store
  - eval $(poetry env activate)
  - poetry install
  - cd ../ 
  - cookiecutter core.dashboards_store/tooling/template 
  ---
  ::
::

::card-grid
---
home: true
---
#title
What's included

#root
:ellipsis{left=0px width=40rem top=10rem blur=140px}

#default

  ::card{icon=lucide:puzzle}
  #title
  Extensible
  #description
  Customize any SQL script, or add your own transformations — you can make the Store your own.
  ::

  ::card{icon=lucide:rocket}
  #title
  Deploy anywhere
  #description
  Deploy and run anywhere using the Docker target.
  ::

  ::card{icon=lucide:settings}
  #title
  Pure dbt
  #description
  Leverage dbt features to build your dashboards: enjoy **tests** and always up-to-date documentation.
  ::

::

::edition-banner
---
icon: lucide:snowflake
cta:
  - Open the Snowflake documentation →
  - https://docs-snowflake.dashboards-store.sciance.ca/fr
---
#title
Using Snowflake?

#description
The Store also comes in a **Snowflake edition**, with its own documentation. Head there to deploy the Store on your Snowflake warehouse.
::
