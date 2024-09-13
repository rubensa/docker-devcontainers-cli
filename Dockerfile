FROM mcr.microsoft.com/devcontainers/base:bookworm

# Specify devcontainer docker-outside-of-docker feature version
ARG DOCKER_OUTSIDE_DOCKER_FEATURE_VERSION=1.5.0
# For version 1.5.0 there is no GIT_TAG
# see: https://github.com/devcontainers/features/issues/1122
# so we use the commit hash instead
# ARG DOCKER_OUTSIDE_DOCKER_FEATURE_GIT_TAG=feature_docker-outside-of-docker_${DOCKER_OUTSIDE_DOCKER_FEATURE_VERSION}
ARG DOCKER_OUTSIDE_DOCKER_FEATURE_GIT_TAG=f5787eed01022f177475a99084327e023a84ddaf

# Install using devcontainer docker-outside-of-docker feature install.sh script
ADD --chmod=700 https://raw.githubusercontent.com/devcontainers/features/${DOCKER_OUTSIDE_DOCKER_FEATURE_GIT_TAG}/src/docker-outside-of-docker/install.sh /tmp/install.sh
RUN /tmp/install.sh && rm -f /tmp/install.sh

# Setup entrypoint to the one specified by devcontainer docker-outside-of-docker feature
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "--" ]

# Specify devcontainer node feature version
ARG NODE_FEATURE_VERSION=1.6.0
#ARG NODE_FEATURE_GIT_TAG=feature_node_${NODE_FEATURE_VERSION}
# For version 1.6.0 there is no GIT_TAG
# see: https://github.com/devcontainers/features/issues/1122
# so we use the commit hash instead
ARG NODE_FEATURE_GIT_TAG=52c79b4963879dd941c67b583199ec7966e41ab4

# Install using devcontainer node feature install.sh script
ADD --chmod=700 https://raw.githubusercontent.com/devcontainers/features/${NODE_FEATURE_GIT_TAG}/src/node/install.sh /tmp/install.sh
RUN /tmp/install.sh && rm -f /tmp/install.sh

# Set nvm env vars specified by devcontainer node feature
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true
ENV PATH=/usr/local/share/nvm/current/bin:${PATH}

# Install devcontainers/cli package
RUN npm install -g @devcontainers/cli

# Run bash by default
CMD [ "/usr/bin/bash" ]
