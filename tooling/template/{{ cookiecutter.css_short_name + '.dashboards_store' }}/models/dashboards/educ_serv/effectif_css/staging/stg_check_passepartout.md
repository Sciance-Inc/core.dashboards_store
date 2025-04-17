# Activer la séparation presco / passe partout dans le tableau de bord de l'effectif

1. Renommer ce fichier en `.sql`
2. Effacer son contentu (mais lisez la suite des inscructions avant de le faire)
3. Implémenter la logique d'identification des exemples membres du programme Passe-Partout
4. Désactiver le modèle `stg_check_passepartout` dans le fichier `dbt_project.yml` de votre projet, dans la **section core**
   1. De cette manière, ce fichier aura précédence sur la définition fournie par le core.