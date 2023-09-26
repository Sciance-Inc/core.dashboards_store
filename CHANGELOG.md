# CHANGELOG



## v0.7.0-dev.2+20230926 (2023-09-26)

### Fix

* fix: removing dead code ([`ddd48d8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ddd48d865f88d65240130a2ae658f51b5c5de232))

### Unknown

* Merge branch &#39;develop&#39; of github.com:Sciance-Inc/core.dashboards_store into develop ([`b0e849a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b0e849ac84fa1d2862de1b424de737129540daac))


## v0.7.0-dev.1+20230925 (2023-09-25)

### Feature

* feat: adding licence ([`23d0f75`](https://github.com/Sciance-Inc/core.dashboards_store/commit/23d0f75707ec43294b83d75512fd5f420bcbb199))

* feat: adding dim_employees ([`3e6a04f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3e6a04f668748ffdccf448efe66a98dd45996da2))

### Unknown

* Merge branch &#39;develop&#39; of github.com:Sciance-Inc/core.dashboards_store into develop ([`89077c5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/89077c553c4deaa1c145c0b4ea484017f7db358d))

* fix : add filtre to compare with curent day date

# Objectives of the Pull Request ?
&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
cette Pr a pour but d&#39;ajouter un filtre pour arreter le calcul des absence à la date du jour
# What is left out of the Pull Request ?
&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

# How to run the pull request ?
&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store and the &lt;cssXX&gt;.data.store folder.
# Update the code
cd core.data.store
git checkout bugfix/abs_date_actu
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../cssvdc.data.store
git checkout develop
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build --select tag:chronic_absenteeism
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
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
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [x]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in... ([`f3c313b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f3c313b4947a98d76968916d20965bf23839d3e7))


## v0.6.2+20230913 (2023-09-13)

### Documentation

* docs(fix): updatating the stamp_model&#39;s macro name ([`25baea2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/25baea243b063291086379f4e273982ec1d8dc9a))


## v0.6.2+20230831 (2023-08-31)


## v0.6.0-dev.6+20230831 (2023-08-31)

### Chore

* chore(cicd): adding concurrency piority ([`4e92676`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4e92676b999d8c60153ec108186532a88e66622f))

### Fix

* fix(cicd): adding job scope to group name ([`7073b1e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7073b1eacd1fb4a960f4f813e1fc4a14b73d40fc))

### Style

* style: applying sqlfmt ([`3f6c45c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3f6c45cd47623973eb5d29d67f75ad647d0cb988))

### Unknown

* Merge branch &#39;master&#39; into develop ([`abd134a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/abd134a53ecb3fd5510244458cb4b68a26803164))

* Merge branch &#39;develop&#39; of github.com:Sciance-Inc/core.dashboards_store into develop ([`2217b56`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2217b56aa01a6bec8bc94c2cb24086dfcda6dda6))


## v0.6.0-dev.5+20230831 (2023-08-31)


## v0.6.1+20230831 (2023-08-31)

### Fix

* fix(cicd): fixing the stable pattern ([`4703193`](https://github.com/Sciance-Inc/core.dashboards_store/commit/47031930755bab9c88cdbe305c96491e4102b2d1))

* fix(cicd): fixing the stable pattern ([`5ada3a1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/5ada3a1ff6cba3792aca4cba24253128bfb3610a))


## v0.6.0+20230831 (2023-08-31)

### Chore

* chore(test): adding the stable version to the nightly build ([`9bf5415`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9bf54155c94ceb7efcc6360de929ba3fefdc31ad))

* chore(cicd): fixing maximal matrix concurrency to 1 to avoid burning the database ([`1b70e2a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1b70e2a29f92be3acafeef3d8040731f4b405c4b))

* chore(fix): logging to the github registry before pushing the docker ([`959c839`](https://github.com/Sciance-Inc/core.dashboards_store/commit/959c8390192a5f3d300f130df0ad312c4be56618))

* chore(cicd): adding the command to run the integration tests suite ([`324f7d5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/324f7d580a4068ba95626db2fece71b5c2dd0ca1))

* chore: trigger the nightly on master ([`c51a9fe`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c51a9fe98f8977f7d60a7e1be1ef0cba159e4b28))

* chore: adding CICD pipeline for nightly release ([`7490540`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7490540f3237eb8e998c25f0daad16ed9df7796a))

* chore(test): adding the dockerfile and the required files to run the integration tests ([`2dac52a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2dac52a81a65d380084f4c46e31fca09b480d1e6))

### Documentation

* docs: updating both the readme and the PR template to help developers populating seeds in the nightly project ([`4718245`](https://github.com/Sciance-Inc/core.dashboards_store/commit/471824523118512dfdda8f948c77e453a2cfda87))

* docs(test): adding an how-to about the way to run the integration test on your local computer ([`b7bfef2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b7bfef28e42badd76d5858e0fcbe5a267837d1c6))

### Test

* test(fix): fixing the test populations ([`df46e63`](https://github.com/Sciance-Inc/core.dashboards_store/commit/df46e639fd4cca1a184d1eea6c1e60a271231f75))

* test: adding a simple /default dbt project to be run as an integration test ([`7687cc6`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7687cc602db01a5d71f4a41f92b46bb5fc6e6ddb))

### Unknown

* Merge branch &#39;develop&#39; of github.com:Sciance-Inc/core.dashboards_store into develop ([`de103bb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/de103bb4ea9a7c07c9ca1db87f573737dd65193f))

* Merge branch &#39;master&#39; of github.com:Sciance-Inc/core.dashboards_store ([`d83ac80`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d83ac80f18d96686b78c26a8a5f1aacf9b223f30))


## v0.5.3 (2023-08-31)


## v0.6.0-dev.4+20230831 (2023-08-31)

### Fix

* fix: adding dummy id_eco to custom_fgj_population so the table is now working when not overrided ([`919f8f1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/919f8f141a31a1cc34537208ece0541efdfe9519))

* fix: the default empty custom population now properly support the id_eco ([`5458983`](https://github.com/Sciance-Inc/core.dashboards_store/commit/54589830d80781e7c9f48536e852e93f97f4bfd6))

### Unknown

* Merge tag &#39;populations&#39; into develop

v0.5.2 ([`9b87f1e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9b87f1ea34ae1c14e5761b63bfd5d535d45e6f1b))


## v0.6.0-dev.3+20230831 (2023-08-31)

### Build

* build(dag): disabling email on failure as I don t have any smtp server ([`740fc8b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/740fc8bfdb25174d37b7a8ac33f97087470b16fa))

### Chore

* chore: adding the sqlfmt linter

# Objectives of the Pull Request ?
&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?

* The PR introduces the `sqlfmt` formatter in the tools chain.
* `sqlfmt` parses the SQL code and produces a formatted version of it.
* The formatted version uses standard style guidelines, that are NOT developer-dependant, resulting in a more coherent developing experience.
* Formatting the SQL code will help developers review other developer&#39;s code

* The PR also adds a `git pre-commit-hook` that can be installed to automagically format the code prior to the commit.
* The pre-commit-hook can be install with the commands documented in the `README.md`

* A new item is added to the `pull-request-template` to remind developers of formatting their code.

# What is left out of the Pull Request ?
&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

* The PR does not decide on whether or not, the particular style-guide of `sqlfmt` should be accepted as-is or tuned. For now, everything is set as default

# How to review the PR ?
* The commit `style: applying fmt` contains ALL newly-styled files.
* I advise you not to first select this commit, as doing so will impair your ability to review the other files.

# How to run the pull request ?
&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store and the cssvdc.data.store folder.

## MIGHT BE core.data.tbe AND cssvdc.data.tbe depending on your setup

# Update the code
cd core.data.store
git checkout feature/linter
git pull

# Install the linter
poetry shell
poetry lock
poetry install

# Might as well install the precommit
pre-commit install

cd ../cssvdc.data.store
git checkout feature/develop
git pull

# Run everything as a sanity check
dbt build --full-refresh
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [X] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request... ([`02da6d3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/02da6d36b50244d1913d0033005931a72f3c3ea5))


## v0.5.2 (2023-08-30)


## v0.6.0-dev.3+20230830 (2023-08-30)

### Fix

* fix: adding the missing is_context_core variable to the cookiecutter

commit 541e66cd7e66564c2c16c99e27da30538469c3b8
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Wed Aug 30 12:58:33 2023 -0400

    fix: adding the missing is_context_core variable to the cookiecutter ([`dd74c08`](https://github.com/Sciance-Inc/core.dashboards_store/commit/dd74c08f285445561204f68053db6311cf284d29))

### Unknown

* Merge tag &#39;core_context&#39; into develop

v0.5.2 ([`b145aa3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b145aa384b2c07c866d134bee8d46031c3f69ce7))


## v0.6.0-dev.2+20230830 (2023-08-30)


## v0.5.1 (2023-08-30)

### Fix

* fix: dependencies will now be parsed as ref when source are used and is_context_core is set to false ([`8e1bb8a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8e1bb8af54c290ad58bf57cfbc5a1381e1ea3b57))

* fix: dependencies will now be parsed as ref when source are used and is_context_core is set to false ([`bbecd17`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bbecd17c288be585cfabdddd41f072a8bf3ddcf3))


## v0.6.0-dev.1+20230830 (2023-08-30)

### Build

* build(fix): addinthe token as an header ([`0b88d89`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0b88d89154b8c1f8b2932776129d909292388691))

* build(fix): addinthe token as an header ([`f70dbc0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f70dbc04c3a7ca327201a5448a165a1496672984))

* build(azure): removing azure build ([`3e86dfa`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3e86dfaac4842adb601e834a4e8d37232561ed09))

* build(azure): swithcing to deep fetch ([`f530e3a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f530e3aab442ce02c93e0364294e94f37793f65b))

* build: update azure-pipelines.yml for Azure Pipelines ([`ded7598`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ded7598a1b0152b0afba8b8f59b898711615044c))

* build: committing on VDC will now push to the sciance repo where tagging happens ;) ([`7bec549`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7bec54986920c34941bc6df899b8a7c1ade204f5))

* build(release): updating the release process ([`ee6cc32`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ee6cc32f90a626a74046d14fa34fed1c486df700))

* build(release): updating the release process ([`32dfa48`](https://github.com/Sciance-Inc/core.dashboards_store/commit/32dfa4854a2667da5826229a9b8e6409aad35765))

### Chore

* chore: removing dead code ([`054b23e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/054b23e67f0937935c91c3b6dd25f775c463a5a3))

### Fix

* fix: the purge_metadata_macro will no be triggered in compile only mode ([`61d6bed`](https://github.com/Sciance-Inc/core.dashboards_store/commit/61d6bedc085a655d428cd690efad7ea6572edece))

* fix: the drop_schema macro won&lt;t try to remove the public schema dbo anymore ([`fef7956`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fef79563b102abe509fc51af1cd3ce8ab7573afc))

* fix: uniformizing the base version of dbt-sqlserver and dbt-core so raised errors are now hidden behin RuntimeExeception anymore ([`8166717`](https://github.com/Sciance-Inc/core.dashboards_store/commit/81667179108c577f9aed935ff43457bd86ed36e0))

* fix(build): fixing the azure target ([`7c9b08b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7c9b08bafbd77ce9863bff2e97a1182b9ba740e3))

### Unknown

* Merge branch &#39;develop&#39; of github.com:Sciance-Inc/core.dashboards_store into develop ([`c6618b7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c6618b7d4763f05f70b6b6dcb18bec7bdca44509))

* Merge branch &#39;master&#39; into develop ([`fcade42`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fcade42eb5bdfb26504f88781280225c575ca240))


## v0.5.0 (2023-08-28)

### Build

* build: pining sr version ([`bfbe029`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bfbe029b484a191bcf813dfc2dd164896c640faa))

* build: casting the timeout as integer to allow for string like definition in the inherited dags ([`761e457`](https://github.com/Sciance-Inc/core.dashboards_store/commit/761e457f69c3a65a9eda7179adebb22046c6e3fe))

### Chore

* chore: updating PR template ([`ffc1028`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ffc1028473f1a26a5e7530f9107350d0080dd2cd))

### Documentation

* docs: fixing typo in the gpi&#39;s database name ([`2b5d591`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2b5d591200f5c646a7daf383848cc4f849a2936b))

### Feature

* feat: add id_eco to population table and add population template

&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
- ajout du id eco au population et la spine
- ajout de modèles de population dans le dossier analyse

&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.store
git checkout feature/modif_spine
git pull
cd ../cssvdc.data.store
git checkout feature/modif_spine
git pull
dbt build
```

&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [x]  I have updated the documentation (README) accordingly to my changes.
  * [x]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [x]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My work item has been moved to `review` in the taskboard.

Related work items: #2323 ([`f7d81ac`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f7d81aced05732d360e56dd2bf0396903916863e))

* feat: update effectif_css dashboard

# Objectives of the Pull Request ?
&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
cette à pour but de mettre à jou le tdb d&#39;effectif avec les norme du template qui a été adopter.
# What is left out of the Pull Request ?
&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

# How to run the pull request ?
&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store and the &lt;cssXX&gt;.data.store folder.
# Update the code
cd core.data.store
git checkout feature/maj_tplt_effectf
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../cssvdc.data.store
git checkout develop
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build --select tag:effectif_css
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [x]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My work item has been moved to `review` in the taskboard.

Related work items: #2291 ([`87007e1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/87007e10a49083771d0932b127d4ff17cb5246ec))

* feat: add id_eco to population table and add population template

&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
- ajout du id eco au population et la spine
- ajout de modèles de population dans le dossier analyse

&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.store
git checkout feature/modif_spine
git pull
cd ../cssvdc.data.store
git checkout feature/modif_spine
git pull
dbt build
```

&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [x]  I have updated the documentation (README) accordingly to my changes.
  * [x]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [x]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My work item has been moved to `review` in the taskboard.

Related work items: #2323 ([`1684b1c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1684b1c7be89ef62f8d59c87aededdc03a743bce))

* feat: adding a cookiecutter template to help greenfield CSS bootstraping the cssXX.data.store

# Objectives of the Pull Request ?
&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?

* The PR adds a cookie cutter template helping new CSS to scaffold the store.
* The template basically populate a folder with a pre-filled `dbt_project.yaml`, a `profiles.yml` file and a github pipelines already configured

# How to run the pull request ?
&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store.
# Update the code
cd core.data.store
git checkout feature/cookiecutter
git pull

poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../

cookiecutter core.data.store/template/

# Enter some dummy vars when prompted for

cd ../

# Check if the you project as been properly scaffolded
ls -l
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [X]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in the taskboard. ([`89397b8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/89397b873f5f1d57508b8362c9983775c4cd6254))

* feat: adding the chronic_absenteeism dashboard

# Objectives of the Pull Request?
* This PR introduces a new dashboard to monitor the chronic absenteeism among students. Chronic absenteeism is defined as a pattern of absence of some sort. The dashboard helps SÉ department monitoring and assess the situation.
* The PR create a new table in the `mart` : `fact_absences_sequence` listing all the absences sequences for the students.
* The dashboard uses the new population mechanism.

# What is left out of the Pull Request ?
* As there was not prototyping phase for this dashboard, some cosmetic / filtering adjustments will have to be made once this dashboard is presented to the clients.

# How to run the pull request ?
You will need a repo with the population tables ... populated. A companion branch has been created on the CSSVDC repo to help you review this PR. The companion branch&#39;s name is `feature/absenteism`. (yes, with  a typo -_-)

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder, where &lt;cssXX&gt; being either CSSVDC or your own repo with a `feature/absenteism` population-enabled branch.

cd core.data.tbe
git checkout feature/absenteeism
git pull
cd ../&lt;cssXX&gt;.data.tbe
git checkout feature/absenteism
git pull
dbt run-operation drop_schema
dbt build --select +tag:chronic_absenteeism
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [X]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in the taskboard. ([`4fa75fa`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4fa75fa9cdeaaebcf5b309eb8b635afc8ce6d90d))

* feat: adding the stamping mechanism to expose the data freshness in the dashboards ([`2c7e0b7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2c7e0b7bb6b14ab6b4bf03cdeea4759bd0ae2f40))

* feat: adding the stamper ([`eb5713a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/eb5713ae3bdf628bacb6c338c6369f2454d3d6f6))

* feat: adding the retirement dashboard. This dashboard monitors the number of retired employees in the past 10 years and provides forecasts for up to 5 years.

# Objectives of the pull request
* This PR adds a new dashboard monitoring the retirement situation.
* A `fact_retirement` and a `fact_active` tables, used as a backbone for the report are introduced in the `human_resources` mart.
* A `fact_retirement_forecasts` is added to the mart as it could be reused in a more strategical dashboard.
* A new seed, `int_sequence_0_to_1000` is introduced. This seed can be cause to generate integer sequences.

# What is left out of the pull request
* Due to the summer break, the human resources&#39; product owner (@&lt;melanie.ranger&gt; ) hasn&#39;t review the dashboard yet. The wording of the dashboard, as well as some cosmetics adjustments following Mélanie&#39;s review will be done in an other pull request.

# How to run the pull request ?

You will need a working development branch with the `human resources` mart enabled and seeds populated as per the `core.develop` branch requirements.
For the **cssvt**, a companion branch (*feature/retirement*) has been created to run and review the pull request.

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder.
# Update the code
cd core.data.tbe
git checkout feature/retirement
git pull
cd ../cssvt.data.tbe
git checkout feature/retirement
git pull

dbt build --select +tag:retirement
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My workw item has been moved to `review` in the taskboard. ([`7727df8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7727df84530a9b7c659f57d7e6e2e5fdbf5df15f))

* feat: adding hooks for implementing custom populations

# Objectives of the pull request

This PR adds an overridable placeholder, acting as an entry point to add custom populations. The placeholders is designed to be overrided in the `cssXX.data.tbe`.

# How to run the pull request ?
&gt; By default the custom populations are empty.

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder.
# Update the code
cd core.data.tbe
git checkout feature/customPopulations
git pull
cd ../&lt;cssXX&gt;.data.tbe
dbt build --select +custom_fgj_populations
```

# Pull request&#39;s checklist

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X} My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My workw item has been moved to `review` in the taskboard.

feat: adding hooks for implementing custom populations ([`d862769`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d862769480ba4f455a9db08386462f1d1cd50319))

* feat: adding fact_permanent_employe

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

Le but principal de cette requête est d&#39;aller chercher l&#39;état de permanence.

Dans cet PR nous considérons que pour avoir une permanence, il faut avoir travailler une période de deux ans, soit à partir de la date de début du poste actuel ou d&#39;un poste dans le même groupe demploi et la date courante et ce sans cessation d&#39;emploi.

Nous sommes conscients qu&#39;il y a une pluralité de définitions sur qu&#39;est-ce que la permanence.

Mais il s&#39;agit d&#39;une définition qui s&#39;applique à tous les CSS

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout **feature/rh_permanence**
git pull
Add a CSV named rh_etat_empl here : cssXX/seeds/marts/human_resources/rh_etat_empl.csvcsv
with the content you can find here : https://dev.azure.com/Centre-Expertise-IA/COTRA-CE/_git/core.data.tbe?path=/seeds/marts/human_ressources/schema.yml&amp;version=GBdevelop&amp;_a=contents
cd ../&lt;cssXX&gt;.data.tbe
dbt build --select tag:rh_permanence
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes. **not applicable**
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [ ]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
![pr.jpg](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/398/attachments/pr.jpg)
  * [X]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have careful... ([`ee01430`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ee014308cd9ec628bfb8d68af90f7b4842521704))

### Fix

* fix: change_dbt_project_name_to_store

&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
- le seul but de cette PR est de corriger le nom du dbt_project du core de &#34;TBE&#34; à &#34;STORE&#34;

&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.store
git checkout bugfix/rename_dbt_project
git pull
cd ../cssvdc.data.store
git checkout develop
git pull
dbt build compile
```

&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [ ]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [ ]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in the taskboard.

fix :change_dbt_project_name_to_store ([`98107ec`](https://github.com/Sciance-Inc/core.dashboards_store/commit/98107ecf0058f7b34eade8cb77e5ec5dd7281dbb))

* fix: typo in doc ([`4dbd33c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4dbd33c4b893d675d2b9db07f52fb96d10136ea0))

* fix: the macro no properly delete the schema and the views ([`313456e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/313456e73549d6764a5ffce7ee99b11db9218810))

* fix(suivi_resultat): correcting seeds&#39; friendly name and mandatory courses

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR a pour but de corriger le nom des épreuves et de les rendre compréhensibles

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/subj_name
git pull
cd ../cssvdc.data.tbe
git checkout develop
git pull
dbt build --select tag:res_epreuves
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [ ]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #2219 ([`ac66eed`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ac66eede2ea8af10d6c38f421ccbfb398f550aed))

### Refactor

* refactor: update effectif_css dashboard to match the template

&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
cette à pour but de mettre à jou le tdb d&#39;effectif avec les norme du template qui a été adopter.
&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.store
git checkout feature/maj_tplt_effectf
git pull
cd ../cssvdc.data.store
git checkout develop
git pull
dbt build --select tag:effectif_css
```

&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [x]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My work item has been moved to `review` in the taskboard.

Related work items: #2291 ([`c6dfc97`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c6dfc975520aafdd528ac61399f3f28753ed155d))

* refactor: renaming TBE to store, uniformizing code accross dashboards and enforcing conventions

# Objectives of the Pull Request ?
* The previous name of the dbt project : `tbe` (_tableau de bord equilibre_) wasn&#39;t making sense. This PR renames the project to `store`.
* The PR cleans the existing code base and improves code consistency across dashboards.
* All dashboards have now their own schema, every single one being prefixed with `dashboard_`
* The `.pbit` files have been plugged into the new schemas
* The deprecated `is_context_core`, an unused varaible has been removed. As a consequence, the `adapt` macro has been removed and every call to this macro has been replaced with the dbt-ic command `{{ source }}`

# What is left out of the Pull Request ?
* The PR does not introduces any changes to the code semantic.

# How to run the pull request ?
__It is advised to rename the folder `core.data.tbe` to `core.data.store` and to update the `&lt;cssXX&gt;.data.tbe/packages.yml` to references `core.data.store`__

__a companion branch (named `uniformization`) has been created in `cssvdc.data.tbe`  to help you review the pull request__

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder.
# Update the code
cd core.data.tbe # OR core.data.store
git checkout feature/uniformization
git pull
cd ../&lt;cssXX&gt;.data.tbe # OR &lt;cssXX&gt;.data.store
git checkout feature/uniformization
git pull

dbt clean
dbt deps
dbt run-operation drop_schema
dbt build --full-refresh
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ X I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [X]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in the taskboard. ([`51cf817`](https://github.com/Sciance-Inc/core.dashboards_store/commit/51cf8177f8d871a3ec5282f04e826e21d299e18b))

* refactor: moving the prospective dashboards s facts to the prospective dashboard folder

# Objectives of the Pull Request ?
* The PR cleans up the educ_serv mart and move back the prospective related files into the prospective dashboard folders.
* As the `fact_freq_fga` and `fact_freq_fga` are only used by the prospective dashboard, it does not make sense to have those tables in the mart. In addition, and since the introduction of the new mechanism population, base population should be directly computed from the `pop*` table.

# What is left out of the Pull Request ?
* The PR does not refactor the prospective dashboard to use the new population tables. This change should be a part of a more profound refactor of the dashboard.

# How to run the pull request ?
&gt; Running the pull request assumes you have the `prospective_tbe` dashboard enabled and configured as per the documentation.

**You must replace `&lt;cssXX&gt;` with the name of a (your ?) running CSS repo with the prospective dashboard enabled.

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder.
# Update the code
cd core.data.tbe
git checkout feature/movingToDashboard
git pull
cd ../&lt;cssXX&gt;.data.tbe
git checkout develop
git pull

dbt build --select +tag:prospectif_cdp
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
* **Pull-request** :
  * [X]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [X]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.

# Commits
refactor: moving the prospective dashboards s facts to the prospective dashboard folder ([`9dc873a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9dc873a3a14e924aa30f35dec80ec9cc5270b90d))

* refactor: renaming ressources -&gt; resources

* This PR correct a typo in the tags and in the models tree. `human resources`  was incorrectly labelled. The supernumerary `s` has been removed.
* This PR actually introduces a breaking change as all inherited dbt project will have to properly rewrite the path to the resources.

You must have a valid `cssXX.data.tbe/dbt_project.yml` configured to use `human_resources` instead of `human_resources`

```bash
cd core.data.tbe
git checkout feature/typoResources
git pull
cd ../&lt;cssXX&gt;.data.tbe
git checkout develop
git pull
dbt build
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My workw item has been moved to `review` in the taskboard.

refactor: renaming ressources -&gt; resources ([`fcdf2ea`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fcdf2eac9200bf4ea16185665f2b87f8c29727c7))

### Unknown

* fix :change_dbt_project_name_to_store

# Objectives of the Pull Request ?
&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?
- le seul but de cette PR est de corriger le nom du dbt_project du core de &#34;TBE&#34; à &#34;STORE&#34;

# What is left out of the Pull Request ?
&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

# How to run the pull request ?
&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store and the &lt;cssXX&gt;.data.store folder.
# Update the code
cd core.data.store
git checkout bugfix/rename_dbt_project
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../cssvdc.data.store
git checkout develop
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build compile
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Template** :
  *  [ ] I have updated the `core/template/{{ cookiecutter.project_slug }}/dbt_project.yml` file accordingly to my changes.
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ]  I have added my CSS lead as a reviewer.
  * [ ]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [ ]  I have carefully reviewd each changes made to a file and made sure the files included on the PR were actually added on purposes.
* **Tasksboard** :
  * [ ] My work item is linked to the pull request.
  * [ ] My work item has been moved to `review` in the taskboard.

fix :change_dbt_project_name_to_store ([`39826f2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/39826f21f15c9bd377181cdbb4fd370f6c9e2946))

* Merge branch &#39;master&#39; of github.com:Sciance-Inc/core.dashboards_store ([`4b2f7c4`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4b2f7c4eb0eff147c54c27dd8ce114164f444031))

* Merge pull request #1 from Sciance-Inc/develop

release v4.0 ([`d949a35`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d949a35459d9b1e764f647e7f023c123fa008549))

* Merge branch &#39;master&#39; into develop ([`5e63ed0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/5e63ed05a982cac97effff517e4bef0a5d6ca093))

* Merged PR 423: Ajout des tags pour les tableaux de bord prospectif_cdp

# Objectives of the Pull Request ?
&gt; Describe the high level purpose of your pull request. What are you trying to achieve ? How are you doing it ?

The goal of this PR is to run the tdb of prospectif_cdp individually or all of them in 1 command. Hence, the addition of these tag mentionned under.

# What is left out of the Pull Request ?
&gt; Describe what is not included in the pull request. Why did you not include it in the PR. What are the next steps ?

Nothing. Everything that we have planned is accomplished so far.

# How to run the pull request ?
&gt; Provide the code required to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.store and the &lt;cssXX&gt;.data.store folder.
# Update the code
cd core.data.store OR cd core.data.tbe
git checkout feature/prospectif_tag
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../&lt;cssvt&gt;.data.store OR .data.tbe
git checkout feature/prospectif_tag
git pull
# Might be required if you add a new DBT dependency
#dbt deps

# Run dbt
Do not forget to run dbt seed --select tag:prospectif_cdp --full-refresh
dbt build --select tag:prospectif_cdp
```

The goal of this PR is this test the tag. Be free to do so.

Tag Available :

prospectif_cdp
res_matieres
anciennete
cout_roulement
emp_retraite
fidelite
emp_retraite

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. Your PR&#39;s review might be delayed otherwise.

First PR with tag. Tag me if something is not right!

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [NA] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per models).
* **Documentation** :
  * [NA]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have set the `set-auto-complete` of the PR and **edited the merge commit message to remove the `Merged PR XXX :` so that my merge message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`**
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented. I have explained the needs for the PR and what was left out of the it.
  * [X]  I have carefully reviewd each changes made to a file and made sure the files included on the PR wer... ([`95729bc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/95729bce26a081503f1f80330433fb17e26f8106))

* Merged PR 412: Bugfix pour res_matieres prospectif_cdp

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

J&#39;ai appliqué une correction d&#39;orthographe sur la seed res_matieres (colonne friendly_name) et j&#39;ai ajouter les tests dans le shema.yml, sans parler des modifications par rapport aux changement du nom de friendly_name également dans le schemal.yml

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder.

Pour rouler le code :

cd core.data.tbe/
git checkout bugfix/prospectif_fix
cd ..
cd cssvt.data.tbe/
git checkout bugfix/prospec_fix
dbt run-operation drop_schema
dbt seed --full-refresh
dbt build --select +prspctf_nb_ele_plus_de_66

```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes. ([`772b670`](https://github.com/Sciance-Inc/core.dashboards_store/commit/772b670179f73960e28b0a030c82cee2c52d1320))


## v0.3.2 (2023-06-26)

### Build

* build: updating version REGEX ([`0688b97`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0688b974ac5d8179d1f62bad3b83a2f842b14a89))

### Fix

* fix: casting the timeout as integer to allow for string like definition in the inherited dags ([`76f17c9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/76f17c9688ec9634251dc40ab6fd07e2ef335f87))

### Unknown

* Merge branch &#39;develop&#39; ([`01026cc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/01026ccf42f02fb33908c8e3d78720cd063b7356))

* Merge branch &#39;develop&#39; ([`09b0f2e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/09b0f2e6c6982c9552fd37fd96b5a2cc7d9d6e6d))

* Merge branch &#39;master&#39; of github.com:Sciance-Inc/core.dashboards_store ([`adccdef`](https://github.com/Sciance-Inc/core.dashboards_store/commit/adccdef7edb24cf2d1ae5de86fa761cf0779c2c1))

* Merge branch &#39;develop&#39; ([`0a1897d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0a1897d2a5fd1d476820004d539fec8fef6ead59))

* Revert &#34;fix | PR comments v2&#34;

This reverts commit 6e15c1181a5591259fccff238c88d59cfade32a8. ([`6edf36e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6edf36e8f908a650fc6d9a99eaefecb78352e6c0))

* fix | PR comments v2 ([`6e15c11`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6e15c1181a5591259fccff238c88d59cfade32a8))

* doc : introduction of the new db template in the store

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

Cette PR a pour seul but d&#39;introduire le fichier PBIX qui va servir de gabarit pour les futures tdb du magasin de la CDP

# How to run the pull request ? ne s&#39;applique pas
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
# Assuming you are in a folder containing both the core.data.tbe and the &lt;cssXX&gt;.data.tbe folder.
# Update the code
cd core.data.tbe
git checkout feature/&lt;feature_name&gt;
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../&lt;cssXX&gt;.data.tbe
git checkout feature/&lt;feature_name&gt;
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build --select tag:&lt;my ressources tag&gt;
```

# Pull request&#39;s checklist
&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [ ] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  I have edited the merge commit message to remove the `Merged PR XXX :` so that my message is something like `&lt;feat|fix|chore|doc|refactor|perf|style&gt;: foo bar`
  * [ ]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #2096 ([`009a47a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/009a47a12cb63568d4d12e44add63d3eeee9bd3e))

* doc: Bonification du readme pour Effectif_css

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

Cette PR modifie aucun code. C&#39;est une bonification fait au readme pour l&#39;effectif_CSS. Aucun test est à faire.

* **Code** :
Ne s&#39;applique pas

Feat : Bonification du readme pour Effectif_css ([`56f5dac`](https://github.com/Sciance-Inc/core.dashboards_store/commit/56f5dac2ab44daa154f95d0f1e0ba6e52494aeb9))


## v0.3.1 (2023-06-08)

### Build

* build: dumping json to keep header properly setted ([`ac37a54`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ac37a54587e7b690fa6ae4f5e9c1e37d65496400))

* build: payalod is now a dictionary to be serialized ([`af2bc21`](https://github.com/Sciance-Inc/core.dashboards_store/commit/af2bc2107eb3451b1d2d5c04932683b4f44aab3d))

* build: adding etl_profile ([`89ecabf`](https://github.com/Sciance-Inc/core.dashboards_store/commit/89ecabf5b192aec1a8e80ac28d5b9998fced6d5a))

* build: forcing the use of the etl_profile to make the etl profile invariant ([`45fe728`](https://github.com/Sciance-Inc/core.dashboards_store/commit/45fe72873f6454e8905d9404e713207da9d3a898))

* build: adding notification to the DBT failure ([`d4d254a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d4d254a30e5e39e2b4df3f353b36392edb00249c))

* build: including the manifest in the dag folder ([`519c244`](https://github.com/Sciance-Inc/core.dashboards_store/commit/519c244c9595762ac66003ec64bb30a71b46126e))

* build: unesting deployment folder ([`c2a19ac`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c2a19ac9c288e61a61840ecab5cc036f71ac0891))

* build: adding support for variable docker host ([`49d8165`](https://github.com/Sciance-Inc/core.dashboards_store/commit/49d81658cb1ae1670032e3a2f34c66a25295f549))

* build: reducing the exported files ([`54f411c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/54f411c4e0a83fe374fd4da8a0e28efba9fb2722))

* build: add profiles and dag file to the image ([`cdcbf0c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cdcbf0c2728935398607261d8e238f6f55e6b347))

### Chore

* chore: adding item to the pull request template ([`690ce92`](https://github.com/Sciance-Inc/core.dashboards_store/commit/690ce926b6817f07285c241ce702352f03c18645))

### Fix

* fix: remove blank results and correct subject evaluation code

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
Cette PR a pour objectif de régler le problème des doublons qui proviennent de la table des résultats ministérielles de Jade. elle corrige aussi des typos dans les codes des matières des épreuves

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout bugfix/doublons_res_epr
git pull
cd ../cssvdc.data.tbe
git checkout develop
git pull
dbt build --select tag:res_epreuves
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #2014 ([`ccf6be0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ccf6be0691b988a37b1886895bae2f37d048407a))

### Refactor

* refactor: defaulting docker URL on local socket ([`388c801`](https://github.com/Sciance-Inc/core.dashboards_store/commit/388c801f9b7315490f9f001d721f902bfa4be0ff))

### Unknown

* Merge branch &#39;master&#39; into develop ([`10f5a8a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/10f5a8aba7cfb44e1a54d6e7626c665da6549df4))

* Merge branch &#39;master&#39; into develop ([`3dde468`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3dde4687fe3dab6b6bc8c8cfa8452b00aaaaf205))


## v0.3.0 (2023-05-30)

### Build

* build: adding CICD

build: adding missing workflows folder

build: adding notifcation of failures

build: renaming staging database to staging

build: adding building of master images

feat: adding semantic release

feat: disabling all release ([`9a4f44b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9a4f44b031986fb0aca18f8fc501503ebda3beaa))

* build: adding semantic release ([`4f63477`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4f6347779246dab3cd92119ce1363903878a020f))

* build: adding CICD

build: adding missing workflows folder

build: adding notifcation of failures

build: renaming staging database to staging

build: adding building of master images

feat: adding semantic release

feat: disabling all release ([`880c233`](https://github.com/Sciance-Inc/core.dashboards_store/commit/880c2332ab79400a727114d147c4cf1675ca4b10))

* build: adding semantic release ([`50412b7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/50412b770f851a48bfe97435c4490b5cd75a26e1))

### Chore

* chore: template typo correction ([`61e5895`](https://github.com/Sciance-Inc/core.dashboards_store/commit/61e589598ef2ce4796b46ae5f0d51c45f7831254))

* chore: template typo correction ([`ff0106d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ff0106d95af7a61a4b859445f91965706783670b))

* chore: adding a pull request template to the repo ([`90876e0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/90876e00f5934785ec172dda66e07a95538bae54))

* chore: empty ([`c4c5e75`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c4c5e757e596c8f5fd3492cd0140b3a03dcaf166))

* chore: empty commit to trigger a revierw from Julie and Nathalie ([`41e940e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/41e940ea8370c0b31dcc04328c8c959d1079cc9d))

* chore: updating dependencies ([`1742559`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1742559a91b4600ceae307dc6b458aef43d21c27))

* chore: adjustment of the schema that describes the emp_conge dashboard scripts ([`0dd8c66`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0dd8c6612bc45fbf7124ab55fa116b48e2da4ee5))

* chore: update README part 2 ([`7ca2503`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7ca2503b469a85f88f74fd7c1fee1d063ae74e32))

* chore: management of the centralized schema ([`184bcba`](https://github.com/Sciance-Inc/core.dashboards_store/commit/184bcbae6218e7b3ed61890819e52d45fb51b4a0))

* chore: update the README ([`339910f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/339910f9d7acb0ebfc3c0f171cc436f28696dee6))

* chore: change the table empcong_fact_emp_conge to fact_emp_conge ([`7c35c1a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7c35c1a4bd8b273e5c0c7baf4154057aeb7b542c))

* chore: adjustment of the schema that describes the dashboard scripts prospective_cdp ([`ecad7fc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ecad7fcd5cb9f1138af8456165bf9d6c4fc16c50))

* chore: adjustment of the schema that describes the emp_conge dashboard scripts ([`52030ce`](https://github.com/Sciance-Inc/core.dashboards_store/commit/52030ceeb75a04223d824f66e296a61c078ce243))

* chore: modification of the dbt_project so that it respects the conventions of the tbe project ([`e3eb436`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e3eb436b2b81f5338224c6e6c2960ab3bf6fb6bc))

* chore: rename the script stg_parc_activ_10y because it is not used to generate a staging table ([`a62f693`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a62f6931183f4eccbda4fba07f5e00afd75400d0))

* chore: rename the script stg_parc_activ_10y because it is not used to generate a staging table ([`bc5ef02`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bc5ef02c259428e92e1bcc2f639ad235ea7fceab))

* chore: modif of the stg_parc_activ_10y script so that it respects the conventions of the project ([`9243d92`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9243d92976f53750aff387275cf5114ec7b2e68d))

* chore: adjustment of the schema that describes the interface tables of the geobus database ([`a5039fb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a5039fb3b03cbc634cfc7cbda7ae88b2aefd89af))

* chore: modification of the i_geobus_parc script so that it respects the conventions of the project (part2). ([`645563a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/645563a5639eadd43b6c92f2a8db7574580696d3))

* chore: adjustment of the schema that describes the interface tables of the piastre database ([`7d415bb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7d415bb55c15cb4cb3c15706360cf96f71a3236e))

* chore: modification of the i_geobus_parc script so that it respects the project conventions ([`4d2b971`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4d2b97174d908b72ef30b5abe1c66d0442d04978))

* chore: move the schema of the &#39;transport&#39; dashboard. 1 schema that centralizes all the information ([`4486f4a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4486f4a1966fcbf4b3fe4b916679feffb2bb1770))

* chore: change the project structure (store structure) ([`5fcf9ea`](https://github.com/Sciance-Inc/core.dashboards_store/commit/5fcf9ea9048ce10d04142e465fcadc1a38667d53))

* chore: put the tests in the macro adapt in comments ([`9de22c2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9de22c2d7b83bf36667813acdad039b9a54d9293))

* chore: update the packages ([`c8056f1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c8056f193c63b54a870a0f61f24aad888281d324))

* chore: update the sources file ([`d56009b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d56009b361081f7c4862082375466ba9e5207386))

* chore: change the project structure (store structure) ([`e3f7715`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e3f7715247fc051f0d3115b287371c1b4b85da10))

* chore: put the tests in the macro adapt in comments ([`2cc4eb8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2cc4eb8fe4fe81db3a0975c502d477cace33ab5d))

* chore: update the packages ([`753951f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/753951ff2b1b2c2d85fb6527e095570598f435ed))

* chore: update the sources file ([`a4b4848`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a4b4848215411490fffe106c26fa887744c26b2e))

* chore: update of the source file which indicates the adapters ([`ad5fbac`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ad5fbac4fea50f7ebe64ff34a4030c4bd4b92edf))

* chore: change the name of the source database ([`13249eb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/13249eb6b4c7ac8ee1ed1af634f9a9ab7c46e81f))

* chore: add schema file for bridges folder ([`0c86ec7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0c86ec7b8376048e992bbb45568124694b2ada7c))

* chore: change keyword pevr by tbe ([`8ba436e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8ba436e1c2458b46671f39cd24d09a0ebe6c523d))

### Documentation

* docs: fixing various typos in the docs and adding a placeholder for populations ([`ccf4f9e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ccf4f9ec694e56bf7db56fede508967be9bb0500))

* docs: fixing a typo in the prospectif_cdep interfaces ([`edc04eb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/edc04eb08177ad0202cc04d2554caf3f3734ab5a))

### Feature

* feat: adding the effectif_css dashboard

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

Le but de ce tdb est de faire le dénombrement de la population au sein d&#39;un centre de service scolaire. La population étant séparé en 4 : Prescolaire, primaire régulier, primaire adapté, secondaire régulier et secondaire adapté.

Cette population est divisé selon le niveau scolaire de l&#39;élève également. PRES4ANS, PRES5ANS, 1er année à la 6ème année, puis 1er secondaire au 5ème secondaire.

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/effectif_css
git pull
cd ../cssvt.data.tbe
git checkout feature/tdb_effectif
git pull
dbt build --select tag:effectif_css
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  *  [X] My work item is linked to the pull request.
  * [X] My workw item has been moved to `review` in the taskboard. ([`eda7eef`](https://github.com/Sciance-Inc/core.dashboards_store/commit/eda7eefc06b8817a74673c056db7d8288792f7c9))

* feat: adding sectors and filter-by-sectors to the transport dashboard

make of filtering of circuits by sectors.

The following section describe the specific for transport scolaire  dashboard in the READEME.md
 __236_ to 252_ lines

How to run the pull request ?
git checkout core.data.tbe/feature/trnsp_secteurs
git pull
cd ../csshc.data.tbe
git checkout transport
git pull
dbt build --select tag:transport

* **Code** :
  * [ x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ x]  I have updated the documentation (README) accordingly to my changes.
  * [ x]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [ x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x ]  I have added my CSS lead as a reviewer.
  * [x ]  My pull request is documented.
  * [x ]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [X ] My work item is linked to the pull request.
  * [X ] My workw item has been moved to `review` in the taskboard.

Related work items: #1935, #1938, #2003 ([`4228f3f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4228f3f5203089e492e0425910da81acfa394082))

* feat: adding the effectif_css dashboard

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

Le but de ce tdb est de faire le dénombrement de la population au sein d&#39;un centre de service scolaire. La population étant séparé en 4 : Prescolaire, primaire régulier, primaire adapté, secondaire régulier et secondaire adapté.

Cette population est divisé selon le niveau scolaire de l&#39;élève également. PRES4ANS, PRES5ANS, 1er année à la 6ème année, puis 1er secondaire au 5ème secondaire.

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/effectif_css
git pull
cd ../cssvt.data.tbe
git checkout feature/tdb_effectif
git pull
dbt build --select tag:effectif_css
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [X]  I have updated the documentation (README) accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [X]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  I have added my CSS lead as a reviewer.
  * [X]  My pull request is documented.
  * [X]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  *  [X] My work item is linked to the pull request.
  * [X] My workw item has been moved to `review` in the taskboard. ([`187080a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/187080aacea2566ae3cbf89c262ed4763c4eaf38))

* feat: adding sectors and filter-by-sectors to the transport dashboard

make of filtering of circuits by sectors.

The following section describe the specific for transport scolaire  dashboard in the READEME.md
 __236_ to 252_ lines

How to run the pull request ?
git checkout core.data.tbe/feature/trnsp_secteurs
git pull
cd ../csshc.data.tbe
git checkout transport
git pull
dbt build --select tag:transport

* **Code** :
  * [ x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ x]  I have updated the documentation (README) accordingly to my changes.
  * [ x]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [ x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x ]  I have added my CSS lead as a reviewer.
  * [x ]  My pull request is documented.
  * [x ]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [X ] My work item is linked to the pull request.
  * [X ] My workw item has been moved to `review` in the taskboard.

Related work items: #1935, #1938, #2003 ([`55888aa`](https://github.com/Sciance-Inc/core.dashboards_store/commit/55888aa73c17656428ae7173c56feaecf6fd0092))

* feat: improvind documentation of the PR template ([`de1f4e4`](https://github.com/Sciance-Inc/core.dashboards_store/commit/de1f4e4fed23413e134e142cb1edb20004a7b9c3))

* feat: ajouter premmiere version du tdb ([`e0695f5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e0695f5cb2b9a201dd29f273ad9f60272c27b6f3))

* feat: adding drop schema macro ([`755d484`](https://github.com/Sciance-Inc/core.dashboards_store/commit/755d48471e9b0f42e8d1fee0b281f221f536625c))

* feat: adding missing seeds in core_dbt_project ([`acdfb01`](https://github.com/Sciance-Inc/core.dashboards_store/commit/acdfb01fded1c915f9f5ffdb5d4c753bbb3bd594))

* feat: adding MatieresEleve  interfaces ([`9045e8f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9045e8f5fe002a2aa5334735f4c417771909c27f))

* feat: add_masse_sal_to_this_table ([`7ad7df0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7ad7df0099d7f7b4bfa3d9d3ded5d68f3da992f0))

* feat: move_table_to_sub_folder_cout_roulement ([`d34758a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d34758afc060f6a9bd1dd802c9b03e0d9c538d0d))

* feat: move_table_to_sub_folder_cout_roulement_and_modify_filter_and_annee_type ([`13f1cab`](https://github.com/Sciance-Inc/core.dashboards_store/commit/13f1cab96c3b246ab98c29e9ee488cb495cc5fa4))

* feat: update_db_delete_dim_table ([`cff22f1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cff22f1937952bda17b31de9955133b57b21613c))

* feat: add taux roulement personnel ([`559dfba`](https://github.com/Sciance-Inc/core.dashboards_store/commit/559dfba0de64e33ad8a93cd6427ba59f55e953fb))

* feat: modify_filter ([`ab3a20e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ab3a20e021b552ce29db801901f33b082797e59e))

* feat: addtable_empl_quitter ([`7c651ba`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7c651baaa56316b5dfc961673a13a68b97dbc5bb))

* feat: delet_shema ([`d84c55a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d84c55a2aba9c08ab2f02fe0ae6864e95455197a))

* feat: add_schema_to_staging_res_etapes_table ([`75d1974`](https://github.com/Sciance-Inc/core.dashboards_store/commit/75d1974ac959c943d16b904bc230048409e13fab))

* feat:  detele_non_used_table ([`dd015e1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/dd015e13761e43daa6f2010a0b8dbd4a7c87a3ad))

* feat: freezing dbt-core and dbt-sql-server to ensure across CSS dependencies consistency ([`034399f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/034399fe2366b351c37d59edd07d9702dd2a7251))

* feat: add_sec4_and_sec4_evaluation_to_db ([`fff74be`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fff74bea543e334fafcbd16dba00fc2c5f874c58))

* feat: add_new_fields_i_e_ri_resultats ([`80c8013`](https://github.com/Sciance-Inc/core.dashboards_store/commit/80c8013616d60f356bf2f9ae223ff7fcb288b7cc))

* feat: add_new_vars_to_dbt_project ([`0ea7623`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0ea7623027d4e557bcfe2638037c5311a54415ab))

* feat: update_README_with_new_info_for_model_res_etapes ([`2250c57`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2250c5751610925d4bb9c4ae78b529cdebf3ff1f))

* feat: add_dashboard ([`d5e2f1a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d5e2f1aae52bf0e57d78a5c75bdb8a3517d9d531))

* feat: add_new_table_to _schema ([`9ed638d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9ed638d8d27d872dad6b892ea05d417ea282f53f))

* feat: add_gouv_evaluation_name _to_seed_table ([`0864ba2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0864ba277b686ed8b8fdc3c9ff5766592f5061ca))

* feat: add_new_interface_table_to_schema ([`fc4a6f6`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fc4a6f617d2deb0ec9d0b484394924bcd5f4b92d))

* feat: extract_gouv_rslt_from_interface_table ([`03c2a43`](https://github.com/Sciance-Inc/core.dashboards_store/commit/03c2a439001f49a4b8181c962429d307902f5a74))

* feat: DB_modification ([`9a93378`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9a93378ef00bbeabffef8b4c3d59af963d7d04ac))

* feat: add_res_exam_anonymous_db ([`adfb628`](https://github.com/Sciance-Inc/core.dashboards_store/commit/adfb628a3a5600cf3d83f475b43a23b34d3ae8e0))

* feat: add_diff_to_school_table ([`7a06431`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7a06431827eab47460bbd1859d4fbd3dd3ade49c))

* feat: add_dbt_utils_package ([`9750664`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9750664c3440d352090d4b34a544104f94af64b0))

* feat: add_id_friendly_name ([`2c266bf`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2c266bfad19d3586da0e4d587e9c103936a53e41))

* feat: add_new_model_emp_cong_to_dbtproject ([`f8d79e8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f8d79e8cd7aac7ed282c83e6cf14cc6ea3cdf81a))

* feat: move_interface_table_cssrepo_to_core_modify_schema.yml ([`3ae9e7b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3ae9e7b789c31c0661a33ce3913ce416da92368e))

* feat: modify_db ([`0c308d9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0c308d9879c66a5c3ad14652ea1319f76cb8bb44))

* feat: change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option) ([`f0ab571`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f0ab571045a14244b6d26404f5a56f064b0f93f2))

* feat: adapt macro test ([`396c665`](https://github.com/Sciance-Inc/core.dashboards_store/commit/396c6656fcd7b5106ee02918c45184dde51f4320))

* feat: add a fact table that tracks the number of part-time employees in the last 10 years ([`a269009`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a269009fbea05dfb568b242b49c870ce1bc76206))

* feat: connection of databases: geobus and piastreto obtain data for analyzing school transport  efficiency ([`1a492b1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1a492b12f0c2a7b9ad48f5ccb048fdfdc3cbd7ee))

* feat: add_new_model_emp_cong_to_dbtproject ([`c3e252e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c3e252ed1d5fd678aaa6111df167ebf91316551f))

* feat: move_interface_table_cssrepo_to_core_modify_schema.yml ([`4494e00`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4494e001c8e8305802e3ecebfbaecdf9e3cf0cbc))

* feat: modify_db ([`1e2281a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1e2281af9cddc4b7cb8338c3bc678a4f1530f31d))

* feat: change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option) ([`6eb0602`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6eb06029a54b3fe941ff2424ab820f6b9c09af1e))

* feat: connection of databases: geobus and piastreto obtain data for analyzing school transport  efficiency ([`3019137`](https://github.com/Sciance-Inc/core.dashboards_store/commit/30191372a6d9814fd5cc32545b60437608b63bc5))

* feat: adapt macro test ([`fd150fe`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fd150fee57c8a5815bdf1a60f111e19dd07df458))

* feat: add a fact table that tracks the number of part-time employees in the last 10 years ([`c56047d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c56047dc2c7dd6f79537b0896b1e22282864811f))

* feat: add base_spine table ([`819cf5a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/819cf5ad3ce05b628d5522e363fc874b05a6d608))

* feat: add stg_populations ([`512146d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/512146d40003a8151877c098b9af7ec48097ce05))

* feat: add adapt macro ([`de7b290`](https://github.com/Sciance-Inc/core.dashboards_store/commit/de7b290b3f442025d2823017a738c87096871e2f))

* feat: adding test  in the core repo ([`a4acb2a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a4acb2a9ab9e16155f780c4caf00b1692918495b))

### Fix

* fix: transports tests are now only executed if the transport is available ([`f2cba73`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f2cba738fad124ede43b68383cea2ec5faef0e08))

* fix: the school filter selection is now limited to one item to avoid misinterpretations with the CSS view

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR ne vise qu&#39;à modifier le filtre de sélection des écoles dans la vue école pour éviter la confusion. quelque utilisateurs utilisait cette vue pour avoir les résultats du css en sélectionnant toute les écoles. en désactivant cette option, les utilisateurs devront utiliser la vue CSS pour cela.
Dans une prochaine PR, je vais apporter des modification pour régler un problème de doublons détecter par les test.

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/res_ep_filter_modif
git pull
cd ../cssvdc.data.tbe
git checkout feature/res_ep_filter_modif
git pull
dbt run-operation drop_schema
dbt seed --full-refresh
dbt run --select tag:res_epreuves
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** : **ne s&#39;apllique pas**
  * [ ] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :  **ne s&#39;apllique pas**
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #2023 ([`6493f0a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6493f0a1e9efafbfd6d72d2fd70d8c96ce9ae361))

* fix: transports tests are now only executed if the transport is available ([`9819602`](https://github.com/Sciance-Inc/core.dashboards_store/commit/98196028ea8e6e24e411a9b0dfa4542ad73b665b))

* fix: the school filter selection is now limited to one item to avoid misinterpretations with the CSS view

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR ne vise qu&#39;à modifier le filtre de sélection des écoles dans la vue école pour éviter la confusion. quelque utilisateurs utilisait cette vue pour avoir les résultats du css en sélectionnant toute les écoles. en désactivant cette option, les utilisateurs devront utiliser la vue CSS pour cela.
Dans une prochaine PR, je vais apporter des modification pour régler un problème de doublons détecter par les test.

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/res_ep_filter_modif
git pull
cd ../cssvdc.data.tbe
git checkout feature/res_ep_filter_modif
git pull
dbt run-operation drop_schema
dbt seed --full-refresh
dbt run --select tag:res_epreuves
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** : **ne s&#39;apllique pas**
  * [ ] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [ ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :  **ne s&#39;apllique pas**
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #2023 ([`9bd5502`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9bd5502bb7db2db069febd4443f91b187d42fe69))

* fix: propagating renaming ([`b91cc30`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b91cc30e6a9a2f86d13f0cc6b9e59d629ed2dcfa))

* fix: updating the code-placeholder since the commands in the placeholders were out of order ([`64f57a9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/64f57a9c51b3380b083cee596891637be51bf8ec))

* fix: removing RLS from the dashboard as we don&#39;t have any RLS table yet ([`9654986`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9654986e524ff9b1d7c39865097931199812398c))

* fix: removing RLS from the dashboard as we don&#39;t have any RLS table yet ([`16b5171`](https://github.com/Sciance-Inc/core.dashboards_store/commit/16b51713e7c1e5fa86fcfc060b6c17df7d88246f))

* fix: correct_error_in_schema ([`f06127a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f06127abbd9a7716da0e7cfdbff063bf8e2f6e13))

* fix: modification of the &#39;transport&#39; dashboard schema ([`ad28b63`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ad28b63fdea5303d1314e9f793d08c5a8290d911))

* fix: adding missing weighting ([`6089aff`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6089affa0723d36d77b6314cd975478643147cfb))

* fix: adding missing weighting ([`6ab5fc2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6ab5fc222820e1d5858095f48231b881ac60304b))

* fix: add_model_prefix ([`b34de7e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b34de7e5f831c05281ebb9be45dfe236cb02cd8e))

* fix: correcti models_name ([`4658d46`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4658d46f81ec7e236309fc91a2e8efaaf75afd55))

* fix: chande_db
_to_PIBT ([`cc3a90d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cc3a90d67ba6189f4a5d90a44293635825c4e63c))

* fix: modify_var_naming ([`6b94094`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6b94094b43f9f11bc23c7563d084d7a257341ba4))

* fix: fixing dbt project ([`e5a0b44`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e5a0b4410d14a32ff9db65606c8dbf900eb0c090))

* fix: removing dead code ([`ffb730f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ffb730fe3bbd89c862c9417c3a73c830e3cccbe6))

* fix: add_prefix_to test_name_to_resolve_ambiguity ([`d0a73cc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d0a73cc6f0fa3dc81f5e5374b3a822b7c76148b2))

* fix: modify version_from_0_to_2 ([`db7cffd`](https://github.com/Sciance-Inc/core.dashboards_store/commit/db7cffdfdc57592db47ff5e14bda7b4b83154aeb))

* fix: updated comments ([`75fddfd`](https://github.com/Sciance-Inc/core.dashboards_store/commit/75fddfdf1a13ab1aa6470e615b4a129f5a81f857))

* fix: add_prefix_to test_name_to_resolve_ambiguity ([`3630b9a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3630b9a876c1a352c3459dfa52f209f29f1cd2fe))

* fix: modify version_from_0_to_2 ([`295485a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/295485a62e51fb8f395ae2fa241c37b9d5393073))

* fix: delet_conflict_message ([`590dbcd`](https://github.com/Sciance-Inc/core.dashboards_store/commit/590dbcdd8c2fb649c7f740917d8f0a5d26eedc8f))

* fix: updated comments ([`9d0e27b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9d0e27bbd55be5c948ba89a11318d13a733f6003))

### Refactor

* refactor: renaming the prspctf_nb_el_fgj table

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR a pour but de  :
   - changer le nom de la table emp_retraite dans les connection de base de donner dans le PBIT du tdb preospectif
   - modifier le code de la table nb_el_fgj pour matcher le changement de la spine
   - modifier un typo dans le template des PR

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
cd ../cssvdc.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
dbt run-operation drop_schema
dbt build --select tag:prospectif_cdp
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #1889

Merged PR 392: refactor: renaming the prspctf_nb_el_fgj table

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR a pour but de  :
   - changer le nom de la table emp_retraite dans les connection de base de donner dans le PBIT du tdb preospectif
   - modifier le code de la table nb_el_fgj pour matcher le changement de la spine
   - modifier un typo dans le template des PR

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
cd ../cssvdc.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
dbt run-operation drop_schema
dbt build --select tag:prospectif_cdp
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #1889 ([`2d116d2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2d116d252ef38b42a119d98eaebf96608c73059f))

* refactor: prospectif_cdp is now using the rh seed from the RH mart

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
- remove prefix from seed name
- delete sources.yml
- add stat_eng to the schema.yml
- modification stat_eng name in fact tables

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout bugfix/correct_bug
git pull
cd ../&lt;cssvdc&gt;.data.tbe
git checkout develop
git pull
dbt build --select tag:prospectif_cdp
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [x]  I have updated the documentation (README) accordingly to my changes.
  * [x]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My work item has been moved to `review` in the taskboard. ([`395fac9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/395fac9c8d3387e19574b942f837bf43536e6739))

* refactor: prospectif_cdp is now using the rh seed from the RH mart

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
- remove prefix from seed name
- delete sources.yml
- add stat_eng to the schema.yml
- modification stat_eng name in fact tables

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout bugfix/correct_bug
git pull
cd ../&lt;cssvdc&gt;.data.tbe
git checkout develop
git pull
dbt build --select tag:prospectif_cdp
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [x] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [x]  I have updated the documentation (README) accordingly to my changes.
  * [x]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [X]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My work item has been moved to `review` in the taskboard. ([`02b2e3c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/02b2e3c1ff885341bcb9ec8015439a44feb1812d))

* refactor: fix the bug introduced earlier ([`059d3fa`](https://github.com/Sciance-Inc/core.dashboards_store/commit/059d3fa4663895f74584d0de6a2cb5a36723edae))

* refactor: test if an error message is sent when dbt test fails ([`d80923b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d80923b11487168885134bcb24fb175b9298b7eb))

### Unknown

* Merged PR 392: refactor: renaming the prspctf_nb_el_fgj table

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR a pour but de  :
   - changer le nom de la table emp_retraite dans les connection de base de donner dans le PBIT du tdb preospectif
   - modifier le code de la table nb_el_fgj pour matcher le changement de la spine
   - modifier un typo dans le template des PR

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
cd ../cssvdc.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
dbt run-operation drop_schema
dbt build --select tag:prospectif_cdp
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #1889

Merged PR 392: refactor: renaming the prspctf_nb_el_fgj table

&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
cette PR a pour but de  :
   - changer le nom de la table emp_retraite dans les connection de base de donner dans le PBIT du tdb preospectif
   - modifier le code de la table nb_el_fgj pour matcher le changement de la spine
   - modifier un typo dans le template des PR

&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected. The following code / placeholder is only provided as documentation / helper to get you started and you will need to adjust it.**

```bash
cd core.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
cd ../cssvdc.data.tbe
git checkout feature/modif_table_name_prspctf_db
git pull
dbt run-operation drop_schema
dbt build --select tag:prospectif_cdp
```

&gt; Please, read carefully each item before checking it. You PR&#39;s review might be delayed otherwise.

* **Code** :
  * [X] The code I m asking a review for is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* **Documentation** :
  * [ ]  I have updated the documentation (README) accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* **Pull-request** :
  * [x]  The code *provided to run the pull request* is working. **I understand that my PR will be rejected as-is otherwise.**
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
  * [x]  I have carefully reviewd each change made to a file and made sure the files included on the PR has been actually changed on purposes.
* **Tasksboard** :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #1889 ([`bf209f1`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bf209f12037358ce601a9a0261dbb0084b643449))

* doc: removing unused code ([`aecabbf`](https://github.com/Sciance-Inc/core.dashboards_store/commit/aecabbffe719b8ed42d007478aa03b8056879866))

* Merged PR 379: refactoring the tree by gathering the dashboards into a dashboard folder and getting rid of the shared folder

# Objectives of the pull request
* This PR refactors the folder tree. The addition of the marts created a confusion between the `marts` and the `shared` folders. The common code had been moved into the `marts` leaving only the interfaces in the `shared` folder.
* A new top level folder : `dashboards` is created, gathering all the dashboards. This helps uncluttering the models between `marts` models and the dashboards-specifics models.
* The `shared` folder is removed, and the `interfaces` and `rls` folders are now top-level folders.
* Adding the dashboards top-level folder is now consistent with the use of the same convention in the `seeds` folder.

As a side effect, the `adapters / sources` files are moved into the dashboard folder they refer to.

What is left out of the PR
The PR does not update the documentation for prospectif_tbe. The deployment procedure is very specific and need to be refactored by itself.

# How to run the pull request ?
&gt; Assuming you are in a folder containing both the core.data.tbe and the cssvdc.data.tbe repos..

This PR use a companion branch : cssvdc.data.tbe/feature/fixingIntegrationProcedures. This branch is not to be merged yet

```
# Update the code
cd core.data.tbe
git checkout feature/refactoringTree
git pull
poetry shell
cd ../cssvdc.data.tbe
git checkout feature/refactoringTree
git pull

dbt build --full-refresh
```

# Pull request&#39;s checklist
* Code :
* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [X]  The provided code is working.
  * [X]  My pull request is documented.
* Taskboard : ([`673fbe7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/673fbe7f411547178ca8ff7a376ab2ac3b7334f4))

* Merged PR 378: fix: readding poetry-lock removed by PR 366

# Objectives of the pull request
* The `poetry.lock` file was removed in !366 . This was a mistake. This PR brings back the file.

# How to run the pull request ?
&gt; Assuming you are in a folder containing `core.data.tbe`

```bash
# Update the code
git checkout bugfix/poetryLock
git pull
poetry install
poetry shell
```

# Pull request&#39;s checklist
* Code :
* Documentation :
* Pull request :
  * [X]  The provided code is working.
  * [X]  My pull request is documented. ([`63b1244`](https://github.com/Sciance-Inc/core.dashboards_store/commit/63b1244c146c773318e3a0a0306a6c49485d4df0))

* Merged PR 377: Simplifying the dashboards integrations by removing the need for seeds.yml files

# Objectives of the pull request
* The PR simplifies the way a dashboard can be deployed by :
  * Updating and uniformizing the documentation for all the dashboards but `prospectif_cdep`
  * Removing the need for integrators to writes `yaml` specifications when creating a seed required by a dashboard.

__Documentation__
The documentation has been reviewed for all existing dashboards. The new table-like-description has been added to all of the store&#39;s dashboard. The `data / dashboard` dependencies section has been removed. A new `additional configuration` section has been added to all dashboards previously using it.

__Seeds__
The `seeds` specification has been moved from `core.data.tbe/dbt_project` to the various and matching `core.data.tbe/seeds/*/**/schema.yml` files. These `schema.yml` files now contain : the seeds&#39; tags, the seeds&#39; schema and the seeds&#39; tests. Consequently, when implementing a seed from the `cssXX` side, it&#39;s not required to create the corresponding `schema.yml` file. Everything is now properly inherited from the core&#39;s definition. Manually repeating the tags and schema was prone to integrator&#39;s errors.

__Integrator&#39;s perspective__
By default, the `seeds` section of the `cssXX.data.tbe/dbt_project.yml` can be safely removed as it&#39;s not needed anymore to enable a seed. Of course, this section can still be used to OVERRIDE the core implementation of a (default) seed. A concrete walkthrough / use case can be found in the `res_epreuves` section of the README.

# What is left out of the PR
* The PR does not update the documentation for `prospectif_tbe`. The deployment procedure is very specific and need to be refactored by itself.

# How to run the pull request ?
&gt; Assuming you are in a folder containing both the `core.data.tbe` and the `cssvdc.data.tbe` repos..

__This PR use a companion branch : cssvdc.data.tbe/feature/fixingIntegrationProcedures. This branch is not to be merged yet__

```bash
# Update the code
cd core.data.tbe
git checkout feature/fixingIntegrationProcedures
git pull
poetry shell
cd ../cssvdc.data.tbe
git checkout feature/fixingIntegrationProcedures
git pull

dbt build --full-refresh
```

# Pull request&#39;s checklist
* Code :
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [X] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [X]  The provided code is working.
  * [X]  My pull request is documented.
* Taskboard : ([`6b3465b`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6b3465b6e836c84e6de15290486adb3eb6df3f1f))

* Merged PR 366: Ajout de la colonne permanence

# Objectives of the pull request

The purpose of the application is to add a filter to the active employee dashboard to identify permanents from others.
To do so, we just need to add a &#39;Oui&#39; or &#39;Non&#39; indicator.

Change SQL code from &#39;model/pni_table/ema_report_empl_actif.sql&#39; to add &#39;permanent&#39; field
Added the interface in &#39;emp_actif/shared/interfaces/i_pai_dos_perc.sql&#39; which contains the field &#39;permanent&#39;.

# How to run the pull request ?

# Update the code
git checkout core.data.tbe/feature/emp_perm
git pull
poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install

# Might be required if have cssdgs.data.tbe cloned
cd ../cssdgs.data.tbe
git checkout develop
git pull
git checkout feature/empl_perm
git rebase develop

# Run dbt
dbt seed --full-refresh
dbt run --select emp_actif

# Test the code
dbt test

# Pull request&#39;s checklist
* Code :
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
  * [x]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [X]  The provided code is working.
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
* Taskboard :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Ajout de la colonne permanence

Related work items: #1783 ([`bb0ab15`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bb0ab15f0e01e878af606498bd4325ada1da0c21))

* Merged PR 354: create and display the indicators Parcours and Circuits in the transport dashboard

# Objectives of the pull request
&gt;  Parcours and Circuits indicators are taken to analyze
How the number of school transport services evolves in 10 years.
What is the difference in service between morning and afternoon?
Also revealed how many routes are served by the same fleet of buses in the morning, afternoon and in general

infrastructure:

** shared/interface/geobus
* i_geo_p_circ.sql - buses (where cod_transp foreign key references subcontractor/transportur)
* i_geo_p_parc.sql - routes (where no_circ foreign key references buses/cercuit) )
* i_geo_x_annee.sql - dimension of school years

** transport/features

* trnsprt_fact_parcours_10an.sql -  list of active routes and buses serving these routes.
* trnsprt_fact_circuits_10an.sql- List of circuits and calcul number the rutts am,pm,total

 ** transport/dimenisions

* trnsprt_dim_ecoles.sql
* trnspt_dim_circ.sql -  unique numbers of circuits for a filter - circuits

 ** transport/pbi_tables
  * rpt_trnsprt_resultat_prc_circ.sql - total summ of cercuits and parcours - calculation by years

** reporting/transport
* rprt_transport_scolaire.pbit

# How to run the pull request ?
&gt;

```bash
# Update the code
git checkout core.data.tbe/feature/trnsp_circ2
git pull
poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
dbt deps
cd ..
git checkout csshc.data.tbe/transport
git pull

# Run dbt
dbt build --select tag:transport
```

# Pull request&#39;s checklist
* Code :
  * [x ] My tables/variables naming follows the conventions described in the `readme.md`.
  * [x ] I have added DBT tests to my models ( `unique` per model).
* Documentation :
  * [x ]  I have updated the documentation accordingly to my changes.
  * [ x]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [x ]  The provided code is working.
  * [x ]  I have added my CSS lead as a reviewer.
  * [ x]  My pull request is documented.
* Taskboard :
  * [ x] My work item is linked to the pull request.
  * [ ] My workw item has been moved to `review` in the taskboard.

Related work items: #1843, #1844, #1845, #1847 ([`c91bcef`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c91bcef29c81100b4757db264f307e0387a3569b))

* Merged PR 374: Revert &#34;feat : ajouter des colonnes a la table interface&#34;

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/&lt;feature_name&gt;
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../&lt;project_name&gt;
git checkout feature/&lt;feature_name&gt;
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build --select tag:&lt;my ressources tag&gt;
```

# Pull request&#39;s checklist
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

Revert &#34;feat : ajouter des colonnes a la table interface&#34;

Reverted commit `9aaefe42`. ([`1382ed2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1382ed211afc65963bd4a5016146960dc271c1b3))

* Merged PR 375: Revert &#34;factor : modifier le nom des table&#34;

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/&lt;feature_name&gt;
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../&lt;project_name&gt;
git checkout feature/&lt;feature_name&gt;
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build --select tag:&lt;my ressources tag&gt;
```

# Pull request&#39;s checklist
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

Revert &#34;factor : modifier le nom des table&#34;

Reverted commit `26ed1b96`. ([`52c85cc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/52c85ccd4000b08cfed9c99b5f38a3d0422f96f0))

* Merged PR 373: Revert &#34;feat: ajouter premmiere version du tdb&#34;

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/&lt;feature_name&gt;
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../&lt;project_name&gt;
git checkout feature/&lt;feature_name&gt;
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Run dbt
dbt build --select tag:&lt;my ressources tag&gt;
```

# Pull request&#39;s checklist
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

Revert &#34;feat: ajouter premmiere version du tdb&#34;

Reverted commit `e0695f5c`. ([`228d33d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/228d33ddd63305ca9bf745579df857f218d1f19c))

* feat : ajouter des colonnes a la table interface ([`9aaefe4`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9aaefe42d1048199808ea15eb81c98651b608b09))

* factor : modifier le nom des table ([`26ed1b9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/26ed1b9604dbe2cbb2a22129d1203ea16069a921))

* doc: updating typo in Fred&#39;S name ([`ba5a2e8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ba5a2e86bfc439d42165b17f826390c0b1d13b85))

* Merged PR 370: adding table of contents to the readme

# Objectives of the pull request
* The PR aims at easing the navigation through the README. As pointed by @&lt;philippe.paquette&gt; the readme contains a lot of information and It might be tough to jump between relevant sections.
* The PR introduces a new Table of Contents, at the top of the readme  :
    * The Table of Contents can be used to jump to the `Dashboards Table` section
* The PR refactor the `Dashboards Table` by adding, for each dashboard, a link to it&#39;s integration guidelines section.

An integrator can now reach a Dashboard&#39;s documentation in two clicks.

# What is left out of the PR
* The PR does not introduce any change to the README&#39;s semantic. The already-out-of-date information is still...well, out of date.

# How to run the pull request ?
&gt; Assuming you are in a folder containing the `core.data.tbe`.

That&#39;s the neat part ! You don&#39;t ! You can review the README in your browser. How lucky are you ?
That being said, if you want the full experience, you can always checkout the branch on your local computer.

```bash
cd core.data.tbe
git checkout feature/fixupDoc
git pull
```

# Pull request&#39;s checklist
* Code :
* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
* Pull request :
  * [X]  The provided code is working.
  * [X]  My pull request is documented. ([`19284fa`](https://github.com/Sciance-Inc/core.dashboards_store/commit/19284fa0c593cfd6af8fcff3e7f86074819a24b8))

* doc: typo in Frederyk&#39;s name ([`72fa85e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/72fa85edfdc0a71eb5dc73e891c4e8833f8ebde2))

* Merged PR 355: Modifier l&#39;âge de départ à la retraite et prendre supérieur ou égale

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

L&#39;objectif était de modifier l&#39;âge du départ à la retraite de 65 à 55 et de ne pas uniquement aller chercher les gens qui avaient 55, mais 55 et plus.

Pour ce faire, nous avons modifié et renommer le fichier **prspctf_rprt_emp65_ann_bdgtr.sql** pour **prspctf_rprt_emp_ge55_ann_bdgtr.sql**

* Avant de rouler cette PR, il faut impérativement excécuter celle de Fréderyk

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/emp_retraite
git pull
poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install

# Run dbt
dbt seed --full-refresh
dbt run --select +prspctf_rprt_emp_ge55_ann_bdgtr
```

# Pull request&#39;s checklist
* Code :
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
  * [x]  The models I have added are documented in a `schema.yml` file.
![image (2).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/355/attachments/image%20%282%29.png)
* Pull request :
  * [x]  The provided code is working.
![image.png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/355/attachments/image.png)
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
* Taskboard :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

chore: change the name of the profile and the project

Related work items: #1770 ([`e3a8c74`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e3a8c74e926127e23db6f58b628ab8001bb1ece8))

* Merged PR 365: Refractor : Moved file related to SE into the mart educ_serv

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

The goal of this PR is to bring the table into ours marts, which is educ_serv. All change needed related to the file being deplaced has been done and we tested beforehand.

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

We used a dbt run to test the whole PR. No error occured.

```bash
# Update the code
git checkout core.data.tbe/feature/refractor_mart_se
git pull

Its should be working in any cssxxx with the dbt_project being up to date.

Add the following to the dbt_project:

models:
    tbe:
        marts:
            educ_serv:
                +enabled: true

# Pull request&#39;s checklist
* Documentation :
  * [x ]  I have updated the documentation accordingly to my changes.
  * [x ]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [x ]  The provided code is working.
* Taskboard :

Refactor : move table into mart serv_educ ([`9b5ac39`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9b5ac39477f5032d221448de115ce0f85143961b))

* Merged PR 364: Ajouté emp_actif.rdl

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*
L&#39;objectif est pour avoir le rapport emp_actif.rdl. On peut l&#39;importer dans PBIRS.

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/report
git pull
# Might be required if you update either the poetry file or the lock file
# poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
cd ../reports
git checkout feature/report
git pull
# Might be required if you add a new DBT dependency
#dbt deps
# Might be required if not have cssdgs.datatbe
#git clone branch develop cssdgs.data.tbe
git clone git@ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/cssdgs.data.tbe
# Might be required if have cssdgs.data.tbe cloned
cd ../cssdgs.data.tbe
git checkout develop
git pull
git checkout feature/report
git rebase develop
# Run dbt
dbt seed --full-refresh
dbt build --select emp_actif
```

# Pull request&#39;s checklist
* Code :
  * [x] My tables/variables naming follows the conventions described in the `readme.md`.
  * [ ] I have added DBT tests to my models (at least a `non null` / `unique` per model).
* Documentation :
  * [x]  I have updated the documentation accordingly to my changes.
  * [ ]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [x]  The provided code is working.
  * [x]  I have added my CSS lead as a reviewer.
  * [x]  My pull request is documented.
* Taskboard :
  * [x] My work item is linked to the pull request.
  * [x] My workw item has been moved to `review` in the taskboard.

Related work items: #1848, #1853 ([`3e7151a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3e7151aad5680a43602fe44fd602a80a240ab59b))

* Merged PR 341: Rehaussement du tdb emp_congé

Le code utilise la base de donnée de la PAIE.

Comment l&#39;exécuter
cd core.data.tbe
git fetch origin
git checkout feature/emp_cong
cd ../cssvt.data.tbe
git fetch origin
git checkout feature/modify_dbt_project

Commandes :
dbt seed --full-refresh
dbt run --select +reporting_emp_cong ([`cc12778`](https://github.com/Sciance-Inc/core.dashboards_store/commit/cc12778404ec462ea3523d194a161cbde00d7fd7))

* Merged PR 357: Refactoring the `integrator` guide

# Objectives of the pull request
* The PR aims at providing a more comprehensive introduction to the ways the store works.
* The PR adds a section with helpful links
* The PR refactors the README in two sections : one for the `integrators` who are deploying dashboard, and one for the `developers` add new dashboard to the repo.

# What is left out of the PR
* The PR only focus on the `integrator` side, as integrator are less used to the store than developers. The developers section will be refactored in an upcoming pull request
* The `prospective_cdep` is left untouched. With the addition of `Marts`, the dashboard&#39;s code should be refactored. It was useless to create a short-lived, and already out of sync documentation. Refactoring the dashboard to use the new `Marts` has been backloged

# How to run the pull request ?
That&#39;s the neat part ! You don&#39;t ! You can review the `README` in your browser. How lucky are you ?
That being said, if you want the full experience, you can always checkout the branch on your local computer.

```bash
cd core.data.tbe
git checkout feature/fixupDoc
git pull
```

# Pull request&#39;s checklist
* Code :
* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
* Pull request :
  * [X]  The provided code is working.
  * [X]  My pull request is documented.
* Taskboard :
  * [X] My work item is linked to the pull request.
  * [X] My work item has been moved to `review` in the taskboard.

Related work items: #1875 ([`2a22c90`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2a22c902e4df98d40312f89b5615e553ec161bd1))

* Merged PR 356: refactor: factoring seed into a mart

# Objectives of the pull request
&gt; The PR uses a companion branch from `cssvdc.data.tbe`. That branch can be safely manipulated by the reviewers.

* The PR aims at moving a seed used in both `emp_actif` and `emp_conge` into a common folder.  As the main job of the store is to factor code, we shouldn&#39;t have to duplicate code. Common code (either `seeds` definitions or fact/dim tables should be stored in a `mart`)
* Since common code is shared, we can&#39;t attach it to only one dashboard. The usual naming convention where seeds are written under the dashboard&#39;s name they belong to does not hold anymore.
* A new convention is used (and documented). Common code schould now be stored under the `marts` folder, UNDER the mart&#39;s name the code belongs to.
* About the marts :
    * Marts are orthogonal to dashboards.
    * Marts are available for both `seeds` and `models`

The `human_resources` is introduced for both the seeds and models. The model mart is currently left empty to keep it consistent with the seed folder.
The `human_resources` mart is populated with a `seed` file definition.
The `emp_actif` dashboard has been refactored to use this new seed.

`core/seeds/marts` should only contains seeds file definition. Actual implementation of the seeds should be done on the cssXX repo. The concrete should be saved under the same folder (but in the cssXX repo) as the definition file.

**Caveat**
* `+schema` and `+tags`  does not work for seeds when set through `dbt_project` (I have raised the issue on the official DBT repo). The whole configuration of the seed, including the tags and schema, is gathered in the `yaml` defining the seed.
* `seeds` are not sensitive to setting `+enabled:true/false` meaning that every non-enabled seed will trigger a warning. (I have raised an issue on the official DBT repo). A `seed` is implicitly enabled by creating a `.CSV` file. As a consequence, every seed defined in a `mart` for which there is no `.CSV` in either the core or the cssXX repo will trigger.

# How to run the pull request ?

```bash
# Update the code
cd core.data.tbe
git checkout feature/refactoringRHMart
git pull
poetry shell
cd ../cssvdc.data.tbe
git checkout feature/refactoringRHMart
git pull
dbt clean &amp;&amp; dbt deps

# Run dbt
dbt run-operation drop_schema # To drop all of the user&#39;s schema
dbt build --select tag:emp_actif
```

# Pull request&#39;s checklist
* Code :
  * [X] My tables/variables naming follows the conventions described in the `readme.md`.

* Documentation :
  * [X]  I have updated the documentation accordingly to my changes.
  * [X]  The models I have added are documented in a `schema.yml` file.
* Pull request :
  * [X]  The provided code is working.

  * [X]  My pull request is documented.
* Taskboard :
  * [X] My work item is linked to the pull request.
  * [X] My workw item has been moved to `review` in the taskboard.

![image.png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c5... ([`941e8b7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/941e8b745c6fe988225138a448b4657cdaede714))

* Merged PR 353: Revert &#34;fix: removing RLS from the dashboard as we don&#39;t have any RLS table yet&#34;

# Objectives of the pull request
&gt; describe the high level purposes of your pull request. What are you trying to achieve ? How are you doing it ?*

# How to run the pull request ?
&gt; Provide the code requiered to run the pull request. This is the code that will be used to review your pull request. **The provided code must work as-is. If a DBT error is raised while running the code, the PR will be rejected.**

```bash
# Update the code
git checkout core.data.tbe/feature/&lt;feature_name&gt;
git pull
poetry shell &amp;&amp; poetry lock &amp;&amp; poetry install
dbt deps
cd ../&lt;project_name&gt;
git checkout &lt;project_name&gt;/feature/&lt;feature_name&gt;
git pull

# Run dbt
dbt build --select tag:&lt;my ressources tag&gt;
```

# Pull request&#39;s checklist
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

Revert &#34;fix: removing RLS from the dashboard as we don&#39;t have any RLS table yet&#34;

Reverted commit `16b51713`. ([`2419722`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2419722ca5c4cd3325deab3d7d04f72976c495ca))

* Merged PR 339: Tableau de bord emp_actif

Ajout le script pour générer la table emp_actif
Ajout le rapport em_actif.pibt dans le répertoire &#39;reporting&#39;
Voir readme (section emp_actif)  avant de rouler le dbt

Related work items: #1614 ([`6f3ba3d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6f3ba3da36d4abf30747115fec9a2aecf89da1e8))

* Merged PR 338: fix: modif unit tests de fact_evaluations_grades_from_dim et du RLS et verif code matière sec 4 et 5

J&#39;ai ajouter une vérification qui s&#39;assure d&#39;aller chercher uniquement les code matières de sec 4 et 5 quand on veut les résultats des examens du ministère sec 4 et 5 (donc exclus sec 2).

J&#39;ai également modifié les unit tests du RLS et j&#39;ai ajouté des unit test pour fact_evaluations_grades_from_dim pour s&#39;assurer qu&#39;on n&#39;obtiens plus de doublon dans cette table.

Related work items: #1619 ([`24849d9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/24849d9d56a6fe4b2f217be9e8311bd3effd4fc1))

* Merged PR 337: fix: modif scripts tables RLS

Modifications des scripts pour la génération des tables du RLS.
J&#39;ai supprimé 2 tables qui n&#39;étaient pas utiles et j&#39;ai modifié le scripts utilisateurs_ecoles.sql pour utiliser le même code que celui utilisé dans prodrome pour produire la table &#34;utilisateurs&#34;.

Related work items: #1676 ([`ee53102`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ee53102033f0e5d55e6760c70dd1481425bbe58d))

* Merged PR 336: fix : Correction d&#39;un erreur d&#39;orthographe

fix : Correction d&#39;un erreur d&#39;orthographe
status -&gt; statut ([`d457ef0`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d457ef026649cfffb4deb85fa603a73f17fc1221))

* Merged PR 330: refactoring cout de roulement code

- réécrire le code pour la table prspctf_fact_emp_quitter
- remplacer la masse salariale de par la masse salariale de l&#39;année précédente dans le calcul du cout de roulement de l&#39;année en cours
- mettre a jours le Readme avec l&#39;explication du calcul de l&#39;indicateur
- pour rouler le code :
cd core.data.tbe
git checkout bugfix/cout_roulement
cd ../css***.data.tbe
git checkout develop
dbt run ([`7adeb5d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7adeb5d8700505c2d462a1905909e8489785a36c))

* Merged PR 317: RLS

Description: produire le code DBT pour générer les tables RLS

**Les ajouts apportés au répertoire core**
models/shared/interfaces/paie :
	i_pai_dos_2.sql 		: avoir le courriel de l&#39;employé.
	i_pai_dos_empl.sql		: avoir le corps d&#39;emploi,état, date effective, lieu et l&#39;emploi principal de l&#39;employé.

**Les modifications apportées au répertoire core**
	i_pai_tab_lieu_trav.sql	: ajouté eco_off pour avoir seulement les écoles.
	schema.yml			: ajouté le nom, tag et description pour les interfaces ajoutés ci-hauts.

**Les ajouts apportés au répertoire core**
models/shared/rls :
	directeurs.sql			: pour pousser l&#39;ETL et la table &#39;directeurs&#39; dans bd
	ecoles.sql				: pour pousser l&#39;ETL et la table &#39;ecole&#39; dans bd
	enseignants.sql		: pour pousser L&#39;ETL et la table &#39;enseignants&#39; dans bd
	utilisateurs_ecoles.sql	: pour pousser L&#39;ETL et la table &#39;utilisateurs_ecoles&#39; dans bd

**Les modifications apportées au répertoire core**
	schema.yml				: ajouté le nom, tag et description pour les modèles ajoutés ci-hauts.

       dbt_project.yml : ajouté les alias suivants
          directeurs:
            +schema: directeurs
          ecoles:
            +schema: ecoles
          enseignants:
            +schema: enseignants
          utilisateurs_ecoles:
            +schema: utilisateurs_ecoles

**Les ajouts apportés au répertoire css**
       dbt_project.yml: ajouté  rls suivant dans la section models/tbe/shared
        rls:
            +enabled: true

**Compilation:**
cd core.data.tbe/
git checkout develop
cd cssdgs.data.tbe/
git checkout develop
dbt run

Related work items: #1474, #1477, #1480 ([`c9d0c47`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c9d0c47e18a387de2061d1b0b150d30084ec2c5a))

* Merged PR 320: Ajout de l&#39;indicateur AI6 et C6

# **Objectif**

Ce PR ajout l&#39;indicateur AI6 (Développer des stratégies de fidélisation innovantes) et C6 (Attirer et retenir du personnel qualifié et engagé) au Dashboard prospectif_cdp.

Le code utilise la base de donnée de la PAIE.

Il manque une fonctionnalité à l&#39;indicateur C6 :
- Filtrer seulement les employés du centre administratif. Cette fonctionnalité a été rajouté en TODO dans le README.

# **Comment l&#39;exécuter**

cd core.data.tbe
git fetch origin
git checkout feature/ratio_anciennete
cd ../cssvt.data.tbe
git fetch origin
git checkout feature/modify_dbt_project

### Commandes :
dbt run --select prspctf_ratio_anc
dbt run --select prspctf_taux_fidelite ([`9fc3b38`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9fc3b3820d795799b847a4d827f4e04bf0a7bc9a))

* Merged PR 314: Update Readme file

Objectifs et indicateurs pour la priorité #1442 TBE# ([`6e9aad3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6e9aad36ea9c0f0c83ee8b50a897224291086083))

* Merged PR 319: fix: removing empty results has we don&#39;t want them to be tracked

# Objective
The PR remove the courses not sanctioned by a result, as tracked by the `result` column.

# How to run it

```bash
cd core.data.tbe
git checkout bugfix/removeEmptyResult
git pull
poetry shell
cd ../cssvdc.data.tbe
git checkout develop
git pull
dbt build --select suivi_resultat
``` ([`1241f1a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1241f1ab4a5bc531d51368edb4215ca54e64be83))

* Merged PR 316: Adding 10 new materials codes

After the validation of the exams/materials codes with CSSHC, were found several ministerial codes of the materials used  by CSSHC. Since these codes are from the ministry, I added them to the default list

1. Added code materials in the seeds/res_eppruves
-   default_subject_evaluation.csv

![image.png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/316/attachments/image.png)

Related work items: #1546 ([`1e98e6d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1e98e6d60d1fece9db8ba2e33ea0dddd7b193cff))

* Merged PR 318: fix: fixing babel misspelling

# Objective
The PR renew the `poetry.lock` file to handle the Babel&#39;s package renaming.

# Commits
fix: fixing babel misspelling

# how to run

```bash
git checkout develop
poetry install
```` ([`1e52c66`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1e52c66a2753533d52afd51060704eb4d3275119))

* Merged PR 309: feat: adding suivi_resultats_s1_s3 dashboard

# Objective
This PR aims at adding a generical `suivi_resultat` dashboard to the store.  The work is heavily inspired by the dashboard in `comite_donnees`. One major difference is that this PR eliminates the `main_course` concept.

The code is based on the GPI database and makes heavy use of the `edo` schema. Two configuration seeds are available: one to configure the courses to be tracked, and one to configure the levels the students are enrolled in we want to track. Both of these seeds can of course be overridden if needed.

Three features are voluntarily left out of the PR:
* This PR DOES NOT implement the RLS for this dashboard, as a generical solution to this issue is going to be worked on by the ops team in the upcoming sprint. A TODO has been added to the README and will be backlogged on this PR acceptance.
* This PR DOES NOT filter on the regular student, as I am going to introduce a generic, shared across dashboard, way to handle populations in an upcoming spring. Once again, a TODO has been added to the README and will be backlogged on this PR acceptance.
* The concept of `re-taking` a course has been left of the PR, as I haven&#39;t found a proper solution to it for now.

# How to run it

## Get the code
&gt; This PR has a companion branch / PR on CSSVDC. You need to checkout the CSSVDC&#39;s to run the PR without additional configuration. !310

```bash
cd core.data.tbe
git fetch origin
git checkout feature/suivi_resultat_s1_s3
cd ../cssvdc.data.tbe
git fetch origin
git checkout feature/suivi_resultat_s1_s3
```

## Optionally : drop all the schemas in your schema / database to start from a clean slate
&gt; Do not run this command when using the service account as it will drop all the development schemas.

```bash
dbt run-operation drop_schema
```

## Load the seeds, run the code and test the table
&gt; Use the `suivi_resultat` tag to limit the ETL to the suivi_resultats nodes.

```bash
dbt build --select suivi_resultat
``` ([`bce8648`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bce8648a3a7e59be5658047ec43296ce1cda66dd))

* Squashed commit of the following:

commit 371c19d136492c0610f0a8ea476f8be6e297523a
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Wed Mar 8 08:47:14 2023 -0500

    chore: removing duiplicated code

commit deef357531ca726d92fc075e5faf606e4d9bf500
Merge: 10baa51 dc3a2fc
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Wed Mar 8 08:28:08 2023 -0500

    Merge branch &#39;feature/avg_pp_rtrt&#39; (HUGO BOSS)

commit dc3a2fcf1c8ce32826e9cd2aac5515dd380a73be
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Tue Mar 7 16:46:55 2023 -0500

    doc: fixing a minor typo in the readme

commit db96146e81c72e6ab8030f8e3b53b146b78be286
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Tue Mar 7 16:45:15 2023 -0500

    doc: updating the readme with the new conventional prefix fgor reporting tables

commit 0b1d6c8385202c28bf318d0996fba13cd17c6201
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Tue Mar 7 16:39:53 2023 -0500

    fix: updating the documentation to better reflect the purpose of the table

commit 79d8d24e21d6fe4507250d983daf6dce1203d657
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Tue Mar 7 16:36:48 2023 -0500

    fix: adding missing documentation and renaming exposed fields to increase readibility

commit d3cf2695d55f3f52a88d3e6c599e43c51e9e501c
Author: hugo juhel &lt;juhel.hugo@stratemia.com&gt;
Date:   Tue Mar 7 16:00:14 2023 -0500

    fix: adding missing codeblock

commit 0de61f52611fe3723cdbbe0419c1bbcdd8796b14
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 15:33:54 2023 -0500

    dox: more accurate description

commit 52f903dcaa304227cf1093ebe988009a26b36ead
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 15:05:12 2023 -0500

    fix: fix errors in columns names

commit 275f64add1abccbd8bb80a53a139eb0725ef87e0
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 13:40:30 2023 -0500

    docs: prospectif_cdep -add seeds employees status

commit 01aa3a5c107b87518f913ff76567c1542d46c014
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 13:37:58 2023 -0500

    refactor: added sources name employees_status

    Co-authored-by: hugoJuhel &lt;juhel.hugo@stratemia.com&gt;

commit fe82436efd4a50825c7a638b69be580799bc1b5d
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Mon Mar 6 15:22:08 2023 -0500

    fix: sorry:) its suppsd to b in the cadention now

commit 6edff6d7ce22fff1b841f43b3b1aba1b5019af24
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Mon Mar 6 11:56:17 2023 -0500

    renamed sql files via the  &#39;prspctf&#39; namecodention

commit 7208e06104d90546cd9721377eed50b12cecb26f
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Thu Mar 2 15:00:08 2023 -0500

    delete extra code from prct_hemp_65an

commit 96c0f3a987a26b322b32129f0f0e553b345d29e0
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Thu Mar 2 14:59:15 2023 -0500

    new table prtc_hemp_65an_1joul.sql

commit 538c9b88584a9f097b4477ffed8e4bcf23d5a7fc
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Thu Mar 2 09:30:42 2023 -0500

    feat: created history_post_permanant.sql

commit 10baa51011ea0589f48b2c1876578c28fb0472c6
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 15:33:54 2023 -0500

    dox: more accurate description

commit 7f7bc50dfaa03324c974971b18a3550d505f4d0b
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 15:05:12 2023 -0500

    fix: fix errors in columns names

commit 440120bcb737c449e5343d28d419b5b29ac5a1b9
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 13:40:30 2023 -0500

    docs: prospectif_cdep -add seeds employees status

commit efc4fc2500b296e988a7ad67bcb13a6706fd0040
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Tue Mar 7 13:37:58 2023 -0500

    refactor: added sources name employees_status

    Co-authored-by: hugoJuhel &lt;juhel.hugo@stratemia.com&gt;

commit 6854def5cd20fa7068fb1611506a82d35b45550d
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Mon Mar 6 15:22:08 2023 -0500

    fix: sorry:) its suppsd to b in the cadention now

commit 865b3ac73161b92961712cde62e85836a0f21edf
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Mon Mar 6 11:56:17 2023 -0500

    renamed sql files via the  &#39;prspctf&#39; namecodention

commit 48087822106bd3b8ed6c2eb0da3b411895aebd4e
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Thu Mar 2 15:00:08 2023 -0500

    delete extra code from prct_hemp_65an

commit c8611d8c4bf581976059c1935c6f399ea8a88331
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Thu Mar 2 14:59:15 2023 -0500

    new table prtc_hemp_65an_1joul.sql

commit 29b5a3f21179de3dc2d77488992f572e2ceb81e0
Author: mazhur &lt;mzhuravlova@cshc.qc.ca&gt;
Date:   Thu Mar 2 09:30:42 2023 -0500

    feat: created history_post_permanant.sql ([`fd54f46`](https://github.com/Sciance-Inc/core.dashboards_store/commit/fd54f46d42754c0359d452d535696b46b14cc455))

* Merged PR 307: typo: fixing typo prevailing the code to compile

typo: fixing typo prevailing the code to compile ([`abd7ad7`](https://github.com/Sciance-Inc/core.dashboards_store/commit/abd7ad7c9952822d1bc4e11094c8aa85f18ba4de))

* Merged PR 306: reorganization of  files insid shared/interface

**1.  i_pai_dos.sql  renemed to i_pai_dos_empl.sql**
-     added comments and new colomn
-      chenge link name to  i_pai_dos in the file:  prspctf_fact_emp_quitter.sql
-     updated schema.yml
**2.   new fil i_pai_dos.sql**
-    updated schema.yml

**3.  renomed i_pai_tab_eat_empl_conge  to i_pai_tab_eat_empl**
-      chenge link name to /models/emp_conge/features/empcong_fact_emp_conge.sql
-     updated schema.yml
**4. **new file pai_tab_stat_eng.sql****

-     updated schema.yml ([`6ec5c81`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6ec5c81cad60b6790596ea10fc1cdaf9f92ed4aa))

* Merged PR 304: creat table for students result indicator

- creat  mat_select dimensions table unioning a default and a custom CSV (if exist)
-  adding MatieresEleve  interfaces
-  add result table by matiere
-  add reporting table with proportion by year
-  add new table to schema

use develop branch in cssvdc to test the PR ([`2337f53`](https://github.com/Sciance-Inc/core.dashboards_store/commit/2337f5360a3906990ee976322adffdfc7914c569))

* Merged PR 302: Calculer le taux de ratio du roulement du personnel

- Créer une nouvelle branche **feature/massesalariale** pour calculer le taux du roulement du personnel
-  Dans le dossier _models_ &gt; dossier _prospectif_cdp_ &gt; dossier _features_ : 3 fichiers sql à exécuter
   - prspctf_fact_emp_quitter.sql : sert à calculer le nombre de postes remplacés
   -  prspctf_fact_masse_sal.sql : sert à calculer la masse salariale du CSS
   -  prspctf_fact_masse_sal_corp_empl.sql : sert à calculer la masse salariale moyenne par corps d&#39;emploi

-  Dans le dossier _models_ &gt; dossier _pbi_tables_ : 1 fichier sql à exécuter
   - prspctf_couts_de_roulement.sql : sert à calculer le taux du roulement du personnel du CSS

- Dans le dossier _models_ &gt; dossier _shared_ &gt; dossier _interfaces_ &gt; dossier _paie_ : 3 tables à exécuter
  - i_pai_cum_budg.sql : lister le matricule, l&#39;année budgétaire, le salaire cumulatif, le corps d&#39;emploi et le code de déduction depuis la table PAI_CUM_BUDG
  - i_pai_dos.sql : lister les éléments depuis la table PAI_DOS
  - i_pai_tab_corp_empl.sql :  lister les éléments depuis la table PAI_TAB_CORP_EMPLOI

Related work items: #1392 ([`f0bd7dc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f0bd7dcb3f926f9c370028daeca78f3b850897e8))

* feat : update_readme_file ([`9f51092`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9f510928af99c80ac3bd9ef0f9edb3b7c508f259))

* feat : add_schema_file ([`93d0238`](https://github.com/Sciance-Inc/core.dashboards_store/commit/93d0238b75d8343cb0885a4bc944ad6269b1602d))

* feat : add new table to schema ([`183e593`](https://github.com/Sciance-Inc/core.dashboards_store/commit/183e593251405b39f19ea5680471076232cf155a))

* feat :  add reporting table with proportion by year ([`71714d5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/71714d5318be0a5d0729bfeb4922003e51675274))

* feat : add result table by matiere ([`e8c22fb`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e8c22fb4c3b8f458d904b5670a278e9d509d9229))

* feat : creat  mat_select dimensions table unioning a default and a custom CSV (if exist) ([`73de2f5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/73de2f5106ebb327ffb586ff5a788aa96c85cee4))

* chore : delete_table ([`eeae365`](https://github.com/Sciance-Inc/core.dashboards_store/commit/eeae365ff9c84bc37d1da6007a31e011012e96f0))

* feat : move_table_to_sub_folder_cout_roulement_and_delete_join_on_fact_masse_sal ([`1b28c84`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1b28c84012302a06ede9495b4eec8e80eef410b9))

* Merge branch &#39;develop&#39; into feature/massesalariale ([`f4244a9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/f4244a919f4f1dada9263e1db6ef48f686bcecb1))

* Merged PR 290: mettre à jour le tdb des résultats aux épreuves

supprimer la table de dimension qui faisait le lien unique entre les deux tables de reporting. ([`c4efc48`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c4efc48792a196fbcfb0b7d225876de85dd07a42))

* Merge branch &#39;feature/massesalariale&#39; of https://dev.azure.com/Centre-Expertise-IA/COTRA-CE/_git/core.data.tbe into feature/massesalariale ([`76ddab5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/76ddab502322b3057e5864b817dee20d6ac4335c))

* Renommer une référence sur masse sal corp empl ([`afc97f3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/afc97f33307a4b7fe3e43e4abacb533d5d6dfc4d))

* Updated prspctf_couts_de_roulement.sql ([`caf735a`](https://github.com/Sciance-Inc/core.dashboards_store/commit/caf735accfae5723abe5b46798ec7ab764ff1173))

* feat taux roulement personnel ([`be7d74f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/be7d74fe93836011e3892b7a27c9c465a52d9a4b))

* Merge branch &#39;feature/massesalariale&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/massesalariale ([`c60dcb5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c60dcb5f040ff073157e26936f1ae23e160655fb))

* feat : creat_fact_emp_quitter ([`56b374e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/56b374ee5e0a3e73ef5cf0043b59672e73a09ea3))

* feat :add_new_field ([`e4f5139`](https://github.com/Sciance-Inc/core.dashboards_store/commit/e4f51394ab1953f9370c92464bf1b70ace47351f))

* feat : add_masse_salariale_tables ([`9fc4f62`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9fc4f622f56e8050be473ed197914ae8e28bb488))

* masse salariale ([`453cf6d`](https://github.com/Sciance-Inc/core.dashboards_store/commit/453cf6d6a3d62e23103af4a072d0de137ad24d45))

* Merged PR 285: création du tableau de bord des résultats aux épreuves

- feat : create_new_db_rslt_etape_epreuves
- Merge branch &#39;develop&#39; into feature/res_etape_db
- feat: add_diff_to_school_table
- feat_add_diff_to_db
- Merge branch &#39;develop&#39; into feature/res_etape_db
- fix: adding missing weighting
- feat: add_res_exam_anonymous_db
- feat: DB_modification
- Merge branch &#39;feature/res_etape_db&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/res_etape_db
- fix: modification of the &#39;transport&#39; dashboard schema
- chore: move the schema of the &#39;transport&#39; dashboard. 1 schema that centralizes all the information
- chore: modification of the i_geobus_parc script so that it respects the project conventions
- modification of the i_piastre script so that it respects the project conventions
- chore: adjustment of the schema that describes the interface tables of the piastre database
- chore: modification of the i_geobus_parc script so that it respects the conventions of the project (part2).
- chore: adjustment of the schema that describes the interface tables of the geobus database
- chore: modif of the stg_parc_activ_10y script so that it respects the conventions of the project
- chore: rename the script stg_parc_activ_10y because it is not used to generate a staging table
- chore: rename the script stg_parc_activ_10y because it is not used to generate a staging table
- chore: modification of the dbt_project so that it respects the conventions of the tbe project
- Merge branch &#39;feature/correctif&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/correctif
- chore: adjustment of the schema that describes the emp_conge dashboard scripts
- chore: adjustment of the schema that describes the dashboard scripts prospective_cdp
- chore: change the table empcong_fact_emp_conge to fact_emp_conge
- chore: update the README
- chore: management of the centralized schema
- chore: update README part 2
- feat: extract_gouv_rslt_from_interface_table
- Commit a3cb1dff: feat : add_gouv_evaluation_result_to_interface_table
- feat : add_adapted_gouv_evaluation_reslt_to_fact_table
- feat: add_new_interface_table_to_schema
- feat: add_gouv_evaluation_name _to_seed_table
- feat: add_new_table_to _schema
- Merge branch &#39;feature/correctif&#39; into feature/res_etape_db
- Merge branch &#39;feature/res_etape_db&#39; into feature/epreuve_unique
- fix: correct_error_in_schema
- feat: add_dashboard
- Changement suite aux modifs sec4 et 5, update version dbt utils 1.0.0 et ajout interface pour num organisation
- Changement pour Mohamed
- feat: update_README_with_new_info_for_model_res_etapes
- feat: add_new_vars_to_dbt_project
- feat:add_new_filter_to_fact_evaluation_minist_sec4_sec5
- feat: add_new_fields_i_e_ri_resultats
- feat: add_sec4_and_sec4_evaluation_to_db ([`d318031`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d318031d02f13b954c96dc62145856bec116162f))

* Merge branch &#39;develop&#39; into feature/epreuve_unique ([`4112485`](https://github.com/Sciance-Inc/core.dashboards_store/commit/41124856a4f9e17b641831bc7ffd282004c58425))

* chore : Change_res_etapes_model_name_to res_epreuves ([`4e95962`](https://github.com/Sciance-Inc/core.dashboards_store/commit/4e95962dfa9a0c434924c2a017db6925aca637a2))

* feat : change_column_name ([`b853738`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b8537389662fff5b3179bd3814dd4184cfb30cca))

* feat : modify_columns_name ([`5941b21`](https://github.com/Sciance-Inc/core.dashboards_store/commit/5941b21f0fee3049ee4b020bd99e037386bd298e))

* doc: adding missing docstring ([`bc11c90`](https://github.com/Sciance-Inc/core.dashboards_store/commit/bc11c90eb45b64ea050042e0b61388e7dda0f67b))

* Updated empcong_fact_emp_conge.sql ([`108caf8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/108caf82843bda3a3e4c1ff08cf86af364da3a55))

* Merged PR 272: Correctifs afin d&#39;harmoniser le process

Ci-dessous un récapitulatif des modifications apportées au répertoire `core`

- `emp_conge` :
1. Pour ne plus voir le message de warning j&#39;ai modifié le schéma du projet.

![image.png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/272/attachments/image.png)

2. J&#39;ai également configuré un alias pour que la table générée dans la base de données soit nommée `fact_emp_conge` plutot que `empcong_fact_emp_conge`

![image (2).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/272/attachments/image%20%282%29.png)

@&lt;Mohamed Sadqi&gt; , @&lt;Gabriel Thiffault&gt;  Assurez-vous que ces modifications n&#39;aient pas d&#39;impact sur le tableau de bord  (le chemin pour accéder à la table plus précisément).

- `prospectif_cdp` : petite coquille dans le schéma du projet qui générait un warning.

![image (3).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/272/attachments/image%20%283%29.png)

- `shared/interfaces/geobus` et `shared/interfaces/piastre` : j&#39;ai fait des modifications afin de respecter les conventions du projet. @&lt;Maryna Zhuravlova&gt;  le nom des champs doit être en minuscule.

     ex:
![image (4).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/272/attachments/image%20%284%29.png)

- `transport` :

1. J&#39;ai modifié le nom du script `stg_parc_activ_10y` par `trnsprt_parc_activ_10y`. Tout d&#39;abord, ce n&#39;est pas une table de staging donc ca ne nécessite pas de préfixe `stg`. Finalement, afin d&#39;avoir un schéma centralisé, j&#39;ai rajouté le prefixe `trnsprt_`

2. J&#39;ai également configuré un alias pour que la table généré dans la base de données soit nommé `parc_activ_10y` plutôt que `trnsprt_parc_activ_10y`

![image (5).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/272/attachments/image%20%285%29.png)

3. En conséquence, j&#39;ai ajusté le schéma qui d&#39;ailleurs ne fonctionnait pas initialement.

@&lt;Maryna Zhuravlova&gt; , assure-toi que ces modifications n&#39;aient pas d&#39;impact sur le tableau de bord. Je pense que le tableau de bord ne retrouvera pas sa table source sachant que son nom a été modifié

- `dbt_project` : j&#39;ai corrigé la section `transport` du fichier pour harmoniser le processus.

![image (6).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/272/attachments/image%20%286%29.png)

- `README` : ajustement de la section `transport`.

@&lt;Maryna Zhuravlova&gt;  je ne comprends pas l&#39;intérêt de la base de données `piastre`. Est-elle vra... ([`aad680e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/aad680e32ce55ac1f3670642c2b2655c4cd8faa6))

* feat:add_new_filter_to_fact_evaluation_minist_sec4_sec5 ([`98a35fe`](https://github.com/Sciance-Inc/core.dashboards_store/commit/98a35fed13d970fd35b6a15fef8e4f5d13eb7add))

* Changement pour Mohamed ([`c0e8382`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c0e8382e18483d6672045d2a8896aee34ac57e57))

* Changement suite aux modifs sec4 et 5, update version dbt utils 1.0.0 et ajout interface pour num organisation ([`28315de`](https://github.com/Sciance-Inc/core.dashboards_store/commit/28315de7f365d0cae8654ef1651fff98610c9d67))

* Merged PR 281: Change the table emp_conge alias

- chore : change_the_table_empcong_fact_emp_conge_to_fact_emp_conge
- chore: adjustment of the schema that describes the emp_conge dashboard scripts ([`c7ada51`](https://github.com/Sciance-Inc/core.dashboards_store/commit/c7ada51e8c1ad94fe44d2cfff5d2871a72908b90))

* chore : change_the_table_empcong_fact_emp_conge_to_fact_emp_conge ([`3829c26`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3829c26ac8bedad8352c0da0be4b3bc96a0ac26b))

* Merge branch &#39;feature/res_etape_db&#39; into feature/epreuve_unique ([`a150e44`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a150e44fa27f63e09b2e2a496768c5d7d3856763))

* Merge branch &#39;feature/correctif&#39; into feature/res_etape_db ([`20e55b5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/20e55b55441a36942d25c1fb3e9ccf62d8424af8))

* feat : add_adapted_gouv_evaluation_reslt_to_fact_table ([`7ec0962`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7ec096242b3637668bbab22afd67bfacfb9392a3))

* Commit a3cb1dff: feat : add_gouv_evaluation_result_to_interface_table ([`0a28ed5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0a28ed57501b89ac5dcf5e9bfba37b945c17dc24))

* Merge branch &#39;feature/correctif&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/correctif ([`7519347`](https://github.com/Sciance-Inc/core.dashboards_store/commit/751934725d09bfb851fb05a8320b72f53d23f935))

* modification of the i_piastre script so that it respects the project conventions ([`472252f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/472252fd42b37279406975b0a70d1a975a53aa6c))

* Merged PR 253: transport_scoler_geobus

Progect  transport scolarite
1.  Add: intregace/piastre and  intregace/geobus
 models/shared/interfaces
- il y a deux nouveaux répertoires. avec deux nouveaux fichiers
-     repo: geobus
-            i_geobus_parc.sql ; schema.yml
       repo: peastre
              i_peustr.sq; ; schema.yml

2.   modele transport
- repo: transport
          stg_parc_active_10y.sql

3.  feat : dbt_project.yml
-     transport:
-         +tags: [&#34;transport&#34;]
-         +materialized: table

4. README.md
![image.png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/253/attachments/image.png)

5.  Gabarite de un tableau de bord de base pour le transport scolaire
-repo: reporting
              transport_gabarit.pbit

Related work items: #1013, #1125 ([`9e98f85`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9e98f854909ec321a51d54daeeecc694705ad802))

* Merge branch &#39;feature/res_etape_db&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/res_etape_db ([`caa07c9`](https://github.com/Sciance-Inc/core.dashboards_store/commit/caa07c9e32fdc237f04d6677ba92e0f96cf105f2))

* Merge branch &#39;develop&#39; into feature/res_etape_db ([`1c8e9f5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/1c8e9f52f77ddb8af96502924c8ce177dae53249))

* feat_add_diff_to_db ([`a3a86d4`](https://github.com/Sciance-Inc/core.dashboards_store/commit/a3a86d4e3a2f52605e31a99ce89338bf64ca1ece))

* Merge branch &#39;develop&#39; into feature/res_etape_db ([`db3743e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/db3743ed55f99ce3a37426211879f793b2a7cbc3))

* Merged PR 267: Add dim epreuve

- add rstps_dim_unique_subj_evaluation : with unique annee friendly_name key
- add id_friendly_name to reporting table to have a unique annee friendly_name key ([`44056af`](https://github.com/Sciance-Inc/core.dashboards_store/commit/44056afe04c483cf84326010d86a61dd6a4d8b32))

* feat : create_new_db_rslt_etape_epreuves ([`5a1552c`](https://github.com/Sciance-Inc/core.dashboards_store/commit/5a1552c2bd1d9a27c67b6c514b2a257cfcbf7772))

* Merged PR 260: Adding data for res_etapes dashboard

# Objective
* The PR aims at adding the metrics table for a new dashboard : res_etapes dashboard.
* The dashboard will display metrics (aggregated either at a school or a CSS level) regarding the success rate to a set of predefined evaluations.
* A set of predefined evaluations, common across al CSS is defined through a seed.
* The PR allows the customization of the evaluations list, by the definition of another seed in the CSS&#39;s specific package. The procedure is described in the README.

# Tables
* `rstps_dim_subject_evaluation` implements the mechanism to look for and add a table of CSS&#39;s specific evaluations to the default ones.
* `rstps_fact_evaluations_grades` and `rstps_fact_evaluations_grades_from_dim` contains a few hooks to later add the data from biodistribution as well as the populations and some CSS&#39;s specific data.

# Commits
- feat: adding GPI&#39;s edo schema interfaces
- feat: adding a subject_evaluation dimensions table unioning a default and a custom CSV
- feat: adding metrics tables
- docs: adding documentation about the dashboard activation
- docs: adding a placeholder for the upcomming dashboard

# How to run and check the PR ?
1. Enable the dashboard in you CSS&#39;s specific dashboard :

```yaml
# cssXX/dbt_project.yml
models:
    tbe:
        res_etapes:
            +enabled: True
```
2. Load the seeds into the database. By default, only the default seed will be loaded. Refer to the README to add your CSS&#39;s specific seed file.

```bash
dbt seed --full-refresh
```

3. Run the dashboard
* As all related resources are tagged with `res_etapes`, you can limit the ETL execution to this dashboard resources by adding a select statement.

```bash
dbt run --select &#39;res_etapes&#39;
```

## VDC reviewers
* A PR with the same name introduces a custom seed table for VDC. ([`6f257ce`](https://github.com/Sciance-Inc/core.dashboards_store/commit/6f257ce68530142c72befdfc05ad0d108752185f))

* Merged PR 263: Ajustement de la macro qui valide la résolution des différentes requêtes

![image.png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/263/attachments/image.png)

l&#39;argument `combination_of_columns` liste l&#39;ensemble des éléments a prendre en compte pour tester l&#39;unicité. Ceux-ci sont décris dans le schema lié au TdB

ex:

![image (2).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/263/attachments/image%20%282%29.png)

Résultante :

![image (4).png](https://dev.azure.com/Centre-Expertise-IA/c2f84ed8-4636-4689-a070-433ecb89a643/_apis/git/repositories/c515b32e-0393-45f8-a0f3-3c2ce78033d2/pullRequests/263/attachments/image%20%284%29.png) ([`aa3f79f`](https://github.com/Sciance-Inc/core.dashboards_store/commit/aa3f79f3f35c40439a4944f0daeb619e53e23d17))

* Merged PR 259: Déterminer le nombre d&#39;élèves total en FP / FGA des 10 dernières années

- feat: add a &#39;vars&#39; field for the jade data source
- feat: make the Jade tables e_ele, e_freq, t_prog accessible
- feat: added interface i_t_service_enseign (WL_Descr + filter)
- feat: add fact_freq_fp
- feat: add fact_freq_fga
- chore: update the schema file
- feat: added tables that count the number of fp fga students by year / school
- chore: update the READMME file

Related work items: #1175 ([`80c98c5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/80c98c53cb3e9bdc442ebd26359610708d1dbd7b))

* Merged PR 254: correction de la branche employé en congé

- refacto: modify_emp_conge_position_in_models_list
- feat : modify_schema.yml_emplacement
- fix: correcti models_name
- fix: add_model_prefix
- Merge branch &#39;develop&#39; into feature/emp_cong_correction ([`ed7feda`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ed7fedad3d7813555b377eb249bfd3b43ed7caae))

* Merge branch &#39;develop&#39; into feature/emp_cong_correction ([`041fca5`](https://github.com/Sciance-Inc/core.dashboards_store/commit/041fca5e939f13b9c117077c15071489c949469a))

* feat : modify_schema.yml_emplacement ([`3615c66`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3615c666c26373fdbbcf0c857a235dca70b4a33b))

* refacto: modify_emp_conge_position_in_models_list ([`ca625a2`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ca625a2c5b1f85fc9f8b331aab58dbcc1bb57a9d))

* Merged PR 251: Comptabiliser le nombre d&#39;eleves inscrits en FGJ

- feat: make tables gpm_e_dan and gpm_t_eco accessible
- feat: update adapt source file
- feat: add a query to group all students registered in FGJ
- feat: add a spine table
- feat: added a query to count the number of students per year, school population
- feat: add a test to make sure that the tables on GPI are resolved by fiche / id_eco
- feat: add tests to ensure the resolution of the population table and base spine table ([`9c5be61`](https://github.com/Sciance-Inc/core.dashboards_store/commit/9c5be6139b8a3add72027ad8b1e9781768739f21))

* Merged PR 246: Création du TDB employés en congé

- feat: add adapt macro
- feat: add stg_populations
- feat: add base_spine table
- chore: change keyword pevr by tbe
- Merged PR 225: Mise à jour du répertoire pour enlever la FP/FGA + répondre au besoin de la User Story 910
- refactor: test if an error message is sent when dbt test fails
- refactor: fix the bug introduced earlier
- chore: add schema file for bridges folder
- chore: change the name of the source database
- chore: update of the source file which indicates the adapters
- chore: update the sources file
- feat: add a fact table that tracks the number of part-time employees in the last 10 years
- Merged PR 238: Cleanage du repertoire core.data.tbe
- Merge branch &#39;develop&#39; into feature/partial_work
- feat: adapt macro test
- chore: update the packages
- chore: put the tests in the macro adapt in comments
- feat: connection of databases: geobus and piastreto obtain data for analyzing school transport  efficiency
- fix: updated comments
- chore: change the project structure (store structure)
- feat: change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option)
- Merge branch &#39;feature/partial_work&#39; into feature/emp_conge
- add request for the employes in holiday and macro for calculate the current year
- Power BI emp_conge added
- Emp_conge - Schema.yml modified
- feat: modify_db
- Merge branch &#39;feature/emp_conge&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/emp_conge
- Merged PR 242: changement structure projet + ajout du projet prospectif_cdp
- Merge branch &#39;develop&#39; into feature/emp_conge
- fix: delet_conflict_message
- feat: move_interface_table_cssrepo_to_core_modify_schema.yml
- Chore: move_filter_from_interface_table_to_fact_table
- feat: add_new_model_emp_cong_to_dbtproject
- fix: modify version_from_0_to_2
- fix: add_prefix_to test_name_to_resolve_ambiguity ([`82dfd05`](https://github.com/Sciance-Inc/core.dashboards_store/commit/82dfd057fca543487c035e6b1fbdbfd25c3ed10b))

* fix : modify_cod_syntax ([`d22ae12`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d22ae122cff30bd44b6a7b90b58611a88b579f59))

* fix : delet_models_duplicat ([`ae81518`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ae815189f16c1fa283455f7c8d60f1accf883687))

* Merged PR 252: solving the between-schemas-tables-names-conflicting

# Commits
- refactor: adding missing schema to increase between tables segregations
- doc: adding documentation about the between-schema-tables-names-conflict
- fix: the schema is now written in full letters

# Objective
## Primary
* The PR aims a documenting a way to solve the `between-schemas-tables-names-conflicting` issue.
* This issue occurs when two tables, in two different projects, share the same name as illustrated by the `fact_absence` in the following files tree

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

## Secondary
* The PR updates the `dbt project` to namespacing the dashboards through the use of schemas.
* The PR also adds a bunch of minor typos corrections (ongoing work) in the readme
* The PR adds a new table in the `README` to identify the owner of the various dashboards.
* The PR writes down some new conventions to be reviewed

# Solution
* The PR updates the `README` with the addition of a new section gathering common DBT issues we might encounter and the corresponding patterns to solve these issues.

# How to run it
* The PR *does not* introduce new code.

# Side effects
* The PR has no side effect that need to be reflected in the css-specific packages ([`8c07c89`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8c07c8959d97d3311cddb5b8e5f25433d06454ee))

* Merge branch &#39;feature/emp_conge&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/emp_conge ([`0c2f970`](https://github.com/Sciance-Inc/core.dashboards_store/commit/0c2f970c622e8200cad650895623e945a7307019))

* Chore: move_filter_from_interface_table_to_fact_table ([`8b66556`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8b6655642e5945cbacf1743e4541a9190a78bfa8))

* Merged PR 242: changement structure projet + ajout du projet prospectif_cdp

- feat: add adapt macro
- feat: add stg_populations
- feat: add base_spine table
- chore: change keyword pevr by tbe
- Merged PR 225: Mise à jour du répertoire pour enlever la FP/FGA + répondre au besoin de la User Story 910
- refactor: test if an error message is sent when dbt test fails
- refactor: fix the bug introduced earlier
- chore: add schema file for bridges folder
- chore: change the name of the source database
- chore: update of the source file which indicates the adapters
- chore: update the sources file
- feat: add a fact table that tracks the number of part-time employees in the last 10 years
- Merged PR 238: Cleanage du repertoire core.data.tbe
- Merge branch &#39;develop&#39; into feature/partial_work
- feat: adapt macro test
- chore: update the packages
- chore: put the tests in the macro adapt in comments
- chore: change the project structure (store structure)
- feat: change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option) ([`8a9d5f3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8a9d5f3067bd345d3ffa7d90cac2c4ff643b412f))

* Emp_conge - Schema.yml modified ([`ec515fc`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ec515fc5cd9837d9eea2d670e0a9fb0c1f282e65))

* Power BI emp_conge added ([`4551885`](https://github.com/Sciance-Inc/core.dashboards_store/commit/45518851010cf590cab94a8b4a0f3f9d166cdce8))

* add request for the employes in holiday and macro for calculate the current year ([`06d8531`](https://github.com/Sciance-Inc/core.dashboards_store/commit/06d8531f7c81282ef3e12eb98ea3d94d838ba80f))

* Merged PR 238: Cleanage du repertoire core.data.tbe

- chore: move PBIX files outside the models folder
- chore: modify the sources database in the dbt_project
- chore: update the schema file for the adapters
- chore: add a schema file for the interfaces
- chore: add a schema file for the bridges folder
- chore: add a schema file for the spines folder ([`ecbe73e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/ecbe73ef5b5f1d78755ef21dfed7a9ea11bc58dd))

* Chore: move_filter_from_interface_table_to_fact_table ([`45aeff3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/45aeff36c66272cf705f0f4dd5554c73d59ef589))

* Merge branch &#39;develop&#39; into feature/emp_conge ([`7ffa1ad`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7ffa1ad80623c907c6defb908e4ba8447316a0d6))

* Merged PR 242: changement structure projet + ajout du projet prospectif_cdp

- feat: add adapt macro
- feat: add stg_populations
- feat: add base_spine table
- chore: change keyword pevr by tbe
- Merged PR 225: Mise à jour du répertoire pour enlever la FP/FGA + répondre au besoin de la User Story 910
- refactor: test if an error message is sent when dbt test fails
- refactor: fix the bug introduced earlier
- chore: add schema file for bridges folder
- chore: change the name of the source database
- chore: update of the source file which indicates the adapters
- chore: update the sources file
- feat: add a fact table that tracks the number of part-time employees in the last 10 years
- Merged PR 238: Cleanage du repertoire core.data.tbe
- Merge branch &#39;develop&#39; into feature/partial_work
- feat: adapt macro test
- chore: update the packages
- chore: put the tests in the macro adapt in comments
- chore: change the project structure (store structure)
- feat: change in the dbt_project to manually activate the dashboards of interest on the css repo (enable option) ([`54a42d4`](https://github.com/Sciance-Inc/core.dashboards_store/commit/54a42d44c13d93f67da63835201d90ae09c16e36))

* Merge branch &#39;feature/emp_conge&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/emp_conge ([`baaa46e`](https://github.com/Sciance-Inc/core.dashboards_store/commit/baaa46e1446b0d45fa385c9a965be8653b906c80))

* Emp_conge - Schema.yml modified ([`3fe7a44`](https://github.com/Sciance-Inc/core.dashboards_store/commit/3fe7a4483a56fca1a1296674c5d581bee91a48ff))

* Power BI emp_conge added ([`90a7678`](https://github.com/Sciance-Inc/core.dashboards_store/commit/90a76781894c6f09cb5cd5264dfae2f2f3bc9406))

* add request for the employes in holiday and macro for calculate the current year ([`d14c453`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d14c453e6c35024e59fe6b51f7e6f3ba5866b1f2))

* Merge branch &#39;feature/partial_work&#39; into feature/emp_conge ([`eee70c3`](https://github.com/Sciance-Inc/core.dashboards_store/commit/eee70c3e7371fda948e6b3efc124ba4cb245ecfb))

* Merge branch &#39;develop&#39; into feature/partial_work ([`b250aea`](https://github.com/Sciance-Inc/core.dashboards_store/commit/b250aea3cfc709fc52f2da1314e2d7a183b2deba))

* Merged PR 238: Cleanage du repertoire core.data.tbe

- chore: move PBIX files outside the models folder
- chore: modify the sources database in the dbt_project
- chore: update the schema file for the adapters
- chore: add a schema file for the interfaces
- chore: add a schema file for the bridges folder
- chore: add a schema file for the spines folder ([`df796e8`](https://github.com/Sciance-Inc/core.dashboards_store/commit/df796e873b2d87ea9a343d08d7eb4be1581122e8))

* Merged PR 225: Mise à jour du répertoire pour enlever la FP/FGA + répondre au besoin de la User Story 910

- feat: creat_tables_and_DB_for_US910
- feat : delete files unused
- refactor: delete old scripts
- feat: update the resolution tests
- feat: update base_spine
- feat: add schema to describe feature tables and test the resolution
- change &#39;pevr&#39; by &#39;tbe&#39;
- refactor: modify the base_spine to use to build the fact_eleve table
- refactor: change pevr suffix byt tbe suffix
- Merge branch &#39;feature/user_story_910&#39; of ssh.dev.azure.com:v3/Centre-Expertise-IA/COTRA-CE/core.data.tbe into feature/user_story_910
- refactor: change profile name ([`d67f287`](https://github.com/Sciance-Inc/core.dashboards_store/commit/d67f28768729aeeaa3002fdc8436a2b295488595))

* Initial commit ([`8c06729`](https://github.com/Sciance-Inc/core.dashboards_store/commit/8c067291f34e3e343a5f69ab0adad73400be7ff2))

* Added README.md ([`7bff872`](https://github.com/Sciance-Inc/core.dashboards_store/commit/7bff872c23024681d4eb67fb731e7b67e09f66d5))
