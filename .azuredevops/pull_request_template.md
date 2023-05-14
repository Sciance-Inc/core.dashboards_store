# Objectives of the pull request
> describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

# How to run the pull request ?
> Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.tbe and the <cssXX>.data.tbe folder.
# Update the code
cd core.data.tbe
git feature/<feature_name>
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell && poetry lock && poetry install 
cd ../<cssXX>.data.tbe
git checkout feature/<feature_name>
git pull  
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt 
dbt build --select tag:<my ressources tag>
```

# Pull request's checklist 
> Please, read carefully each item before checking it. You PR's review might be delayed otherwise.

* **Code** :
  * [ ] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** : 
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** : 
  * [ ]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [ ]  My pull request is documented.
  * [ ]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My workw item has been moved to `review` in the taskboard.





