FROM ghcr.io/sciance-inc/core.dashboards_store_depechecode:sqlserver

# Install Poetry use it to inject the project dependencies
COPY pyproject.toml pyproject.toml
RUN poetry install --no-interaction --no-ansi --only main --no-root