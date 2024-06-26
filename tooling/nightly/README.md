
# Core.store : nightly
> Integration testing of dev and release-candidate branches.

## Why ?
* Code submitted through pull-requests is only tested in isolation from other PR. 
* Two, isolated PR which are working fine on their own, may not work well together.
* We need to test the integration of all PRs, before releasing a new version.

This sub-directory holds a smôôôl `dbt project`, named `nightly.data.store`, behaving like a regular `cssXX.data.store` project, but with all models and tests enabled. This project is run nightly (hence the name) to test the integration of all PRs against a real database.

Only the last tagged `dev` and `rc` versions of the day are tested.

If the tests / compilations / runs fail, we get the next day to fix the build ;).

## How ?
* The `nightly` run is triggered by a GitHub Action.

## What schould I do ?
* Every developer adding a dashboard / models to the `core.data.store` project should ensure that the `nightly` project has the new mart/dashboard/model/tests/seed enabled.

To update the `nightly` project :
* Update the `nightly/project/dbt_poject.yml` and enable your model.
* Populate any required seed data in `nightly/project/seeds/` and as per your documention.
    * Data outputed by the nightly build will never be looked at, providing the tests are passing. So you don't have to care about the business logic of your seed data. Just make sure it's plausible enough to leverage the tests suite.

## I'am a fancy boïïï, how can I run the integration tests suite locally ?
> Great idea, by doing so you can make sure your changes work well with the rest of the project before submitting your PR !

1. Add the nightly profile to your `dbt_project.yml` :

```yaml
nightly_profile:
  target: <target_name>
  outputs:
    # The target to be used by default, to work on the database without tampering with neither the production data, nor the others schemas
    <target_name>:
      type: fabric
      driver: "ODBC Driver 17 for SQL Server"
      server: <database ip> # The IP of the integration database
      database: store_nightly
      schema: <the database schema to use>
      user: <database's user>
      password: <user's password>
      trust_cert: True
      threads: 1
```


1. cd to the `nightly` project directory :

```bash
cd tooling/nightly/dbt
```

2. Manually (hum... I have got to work on that) the `packages.yml` file to include the LOCAL `core.dashboards_store` project :

```yaml
packages:
  - local: <path to the folder containing the core>/core.dashboards_store
```

3. Recycle the dependencies, build the project and run the tests : 

```bash
dbt clean
dbt deps
dbt build
```

4. Revert / do not commit, the changes you have done to the packages file : 

```bash
git checkout -- packages.yml
```

## How to build and the run the dockerized nightly project locally ?
> This is not required, but can be useful to debug the nightly project. You will need an ssh key with access to the `github/Sciance-Inc/core.data.store` repository. Docker must also be installed.

### How to build it ? 

```bash
# Clone the core.data.store repository
cd core.data.store
eval $(ssh-agent)  # So the SSH key can be used by buildx
ssh-add ~/.ssh/id_rsa # Add your ssh key to the ssh-agent, you might choose another key than id_rsa
docker buildx build --ssh default -f tooling/nightly/docker/Dockerfile . -t nightly --build-arg CORE_VERSION=<core_version> --build-arg TARGET=<rc|dev>
```
Where `<core_version>` schould be set to the tag you want the integration to be tested for.

### How to run it : 

```bash
docker run --env-file=.env nightly integration
```

Where `.env` is a file containing the following variables : 

```bash
DBT_USERNAME=<DBT_USERNAME>
DBT_PASSWORD=<DBT_PASSWORD>
DBT_SERVER=<DBT_SERVER>
DBT_PORT=<DBT_PORT>
```

Each placeholder should be replaced by the appropriate value.




