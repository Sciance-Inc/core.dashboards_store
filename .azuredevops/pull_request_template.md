# Objectives of the Pull Request ? 
> Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?

# What is left out of the Pull Request ? 
> Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

# How to run the pull request ?
> Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store and the <cssXX>.data.store folder.
# Update the code
cd core.data.store
git checkout feature/<feature_name>
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell && poetry lock && poetry install 
cd ../<cssXX>.data.store
git checkout feature/<feature_name>
git pull  
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt 
dbt build --select tag:<my resources tag>
```

# Pull request's checklist 
> Please, read carefully each item before checking it. Your PR's review might be delayed otherwise.

* **Code** :
  * [ ] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
  * [ ] I have formatted the code with the help of `sqlfmt .`.
  * [ ] Did you add a new **mandatory seed** ? If so, have you populated the `nightly` project with your new seed ?
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** : 
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** : 
  * [ ]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `<feat|fix|chore|doc|refactor|perf|style>: foo bar`**
  * [ ]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [ ]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [ ]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in the taskboard.





