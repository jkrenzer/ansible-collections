FROM python:3.12-slim as base
ARG WORK_DIR=/workspaces/ansible-collections
ARG ANSIBLE_COLLECTIONS_PATH=/root/.ansible/collections/ansible_collections
ARG COLLECTION_NAMESPACE=jkrenzer
ARG COLLECTION_DIR=$WORK_DIR/$COLLECTION_NAMESPACE

ENV WORK_DIR=$WORK_DIR
ENV ANSIBLE_COLLECTIONS_PATH=$ANSIBLE_COLLECTIONS_PATH
ENV DEBIAN_FRONTEND=noninteractive
ENV POETRY_VIRTUALENVS_CREATE=false
ENV COLLECTION_DIR=$COLLECTION_DIR

RUN apt-get update && apt-get install -y \
  krb5-user \
  git

FROM base as builder

RUN apt update && apt install -y --no-install-recommends -y \
  build-essential \
  locales \
  git \
  git-lfs \
  libkrb5-dev \
  && rm -rf /var/lib/apt/lists/*
RUN pip3 install poetry

FROM builder as devcontainer

COPY pyproject.toml .
COPY poetry.lock .
RUN poetry install --with=dev
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; locale-gen
RUN git lfs install

FROM devcontainer AS final

COPY ./* .
RUN pre-commit install --config .config/pre-commit.yaml --install-hooks
