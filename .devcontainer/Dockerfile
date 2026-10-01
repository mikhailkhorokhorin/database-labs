FROM mcr.microsoft.com/devcontainers/base:trixie

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql \
        postgresql-client \
        python3 \
        python3-venv \
        pre-commit \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add safe.directory '*'
