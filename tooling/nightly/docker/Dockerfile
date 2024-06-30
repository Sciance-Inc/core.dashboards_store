FROM ghcr.io/sciance-inc/core.dashboards_store_depechecode:sqlserver

# Fetch the core version to run the integration tests against
ARG CORE_VERSION
ARG TARGET

# Configure the build parameters    
ENV DBT_CORE_VERSION=$CORE_VERSION
ENV DBT_TARGET=$TARGET

# Install Poetry use it to inject the project dependencies
COPY pyproject.toml pyproject.toml
RUN poetry install --no-interaction --no-ansi --only main --no-root

# Add the Integration script 
COPY tooling/nightly/docker/integration /usr/local/bin/integration
RUN chmod +x /usr/local/bin/integration

# Override the integration profile
COPY tooling/nightly/docker/profiles.yml /root/.dbt/profiles.yml

# Copy the nightly code
COPY tooling/nightly/dbt/seeds seeds
COPY tooling/nightly/dbt/models models
COPY tooling/nightly/dbt/dbt_project.yml dbt_project.yml
COPY tooling/nightly/dbt/packages.yml packages.yml
# Install the specified version of the core.
RUN --mount=type=ssh poetry run dbt deps