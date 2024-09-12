# Docker image based on devcontainers/base image with devcontainers/cli

This is a Docker image based on [devcontainers/base](https://mcr.microsoft.com/en-us/product/devcontainers/base) with [docker-outside-of-docker](https://github.com/devcontainers/features/tree/main/src/docker-outside-of-docker) and [node](https://github.com/devcontainers/features/tree/main/src/node) features installed along with [devcontainers/cli](https://www.npmjs.com/package/@devcontainers/cli) node package.

This allows for local devcontainer image builds beforeahead the image is ready to be built using [devcontainers/ci](https://github.com/devcontainers/ci) GitHub Action.

## Building

You can build the image like this:

```
#!/usr/bin/env bash

DOCKER_REPOSITORY_NAME="rubensa"
DOCKER_IMAGE_NAME="devcontainers-cli"
DOCKER_IMAGE_TAG="latest"

docker buildx build --platform=linux/amd64,linux/arm64 --no-cache \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  --label "maintainer=Ruben Suarez <rubensa@gmail.com>" \
  .

docker buildx build --load \
  -t "${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" \
  .
```

## Running

You can run the container like this:

```
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
```

Inside the container you should be able to build a devcontainer image which definition is under current directory's _.github_ folder (containing the _.devcontainer_ folder with the _devcontainer.json_ file) by running:

```bash
devcontainer build --workspace-folder ${CONTAINER_WORKSPACE_FOLDER}/.github --image-name ghcr.io/nextail/${PWD##*/}-devcontainer --no-cache
```

as `CONTAINER_WORKSPACE_FOLDER` env variable contains the path for the current host directory that is bind mounted inside the container.