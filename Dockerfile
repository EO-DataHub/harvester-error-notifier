# syntax=docker/dockerfile:1
FROM python:3.11-slim-bullseye

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -y && apt-get upgrade -y

WORKDIR /harvester_error_notifier
ADD LICENSE requirements.txt ./
ADD harvester-error-notifier ./harvester-error-notifier/
ADD pyproject.toml ./
RUN --mount=type=cache,target=/root/.cache/pip pip3 install -r requirements.txt .

# Change as required, eg
#  CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0", "-k", "uvicorn.workers.UvicornWorker", "--log-level", "debug", "mymodule.main:app"]
CMD python -m my.module

