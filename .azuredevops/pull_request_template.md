# Objectives of the pull request
> describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

# How to run the pull request ?
> Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/<feature_name>
git pull
poetry shell && poetry lock && poetry install
dbt deps
cd ../<project_name>
git checkout <project_name>/feature/<feature_name>
git pull  

# Run dbt 
dbt build --select tag:<my ressources tag>
```

# Pull request's checklist 
* Code :
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* Documentation : 
  * [ ]  I have updated the documentation accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* Pull request : 
  * [ ]  The provided code is working.
  * [ ]  I have added my CSS lead as a reviewer.
  * [ ]  My pull request is documented.
* Taskboard :
  * [ ] My work item is linked to the pull request.
  * [ ] My workw item has been moved to `review` in the taskboard.





