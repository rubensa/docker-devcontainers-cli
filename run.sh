#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="rubensa"
DOCKER_IMAGE_NAME="devcontainers-cli"
DOCKER_IMAGE_TAG="latest"

prepare_docker_outside_of_docker() {
  MOUNTS+=" --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker-host.sock"
}

prepare_workspace() {
  ENV_VARS+=" --env=CONTAINER_WORKSPACE_FOLDER=/workspaces/${PWD##*/}"
  MOUNTS+=" --mount type=bind,source=${PWD},target=/workspaces/${PWD##*/}"
}

prepare_docker_outside_of_docker
prepare_workspace

docker run --rm -it \
  ${ENV_VARS} \
  ${MOUNTS} \
  "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" "$@"
