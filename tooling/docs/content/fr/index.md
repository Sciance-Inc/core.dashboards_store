---
title: Accueil
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
  - Commencer
  - /fr/introduction/introduction
secondary:
  - Ouvrir sur GitHub →
  - https://github.com/Sciance-Inc/core.dashboards_store
---

#title
Aider les enfants, un *dashboard* à la fois.

#description
Écrivez du SQL avec [*dbt*](https://docs.getdbt.com/), exécutez un *ETL* conteneurisé avec [Docker](https://www.docker.com/) et exploitez votre entrepôt de données avec [*Power BI*](https://powerbi.microsoft.com/).

#extra
  ::list
  - **+10 *dashboards*** prêts à l'emploi
  - Des valeurs par défaut raisonnables dès l'installation
  - Des ***dashboards*** et ***scripts* SQL** entièrement configurables
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
Ce qui est inclus

#root
:ellipsis{left=0px width=40rem top=10rem blur=140px}

#default

  ::card{icon=lucide:puzzle}
  #title
  Extensible.
  #description
  Personnalisez n'importe quel *script* SQL ou ajoutez vos propres transformations: vous pouvez vous approprier le Store.
  ::

  ::card{icon=lucide:rocket}
  #title
  Déployer partout
  #description
  Déployez et exécutez le Store n'importe où avec la *target* Docker.
  ::

  ::card{icon=lucide:settings}
  #title
  Pur *dbt*
  #description
  Utilisez les fonctionnalités de *dbt* pour construire vos *dashboards*: profitez de **tests** et d'une documentation toujours à jour.
  ::

::
