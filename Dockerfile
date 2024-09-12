FROM mcr.microsoft.com/devcontainers/base:bookworm

# Specify devcontainer docker-outside-of-docker feature version
ARG DOCKER_OUTSIDE_DOCKER_FEATURE_VERSION=1.3.2

# Install using devcontainer docker-outside-of-docker feature install.sh script
ADD --chmod=700 https://raw.githubusercontent.com/devcontainers/features/feature_docker-outside-of-docker_${DOCKER_OUTSIDE_DOCKER_FEATURE_VERSION}/src/docker-outside-of-docker/install.sh /tmp/install.sh
RUN /tmp/install.sh && rm -f /tmp/install.sh

# Setup entrypoint to the one specified by devcontainer docker-outside-of-docker feature
ENTRYPOINT [ "/usr/local/share/docker-init.sh", "--" ]

# Specify devcontainer node feature version
ARG NODE_FEATURE_VERSION=1.4.0

# Install using devcontainer node feature install.sh script
ADD --chmod=700 https://raw.githubusercontent.com/devcontainers/features/feature_node_${NODE_FEATURE_VERSION}/src/node/install.sh /tmp/install.sh
RUN /tmp/install.sh && rm -f /tmp/install.sh

# Set nvm env vars specified by devcontainer node feature
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true
ENV PATH=/usr/local/share/nvm/current/bin:${PATH}

# Install devcontainers/cli package
RUN npm install -g @devcontainers/cli

# Run bash by default
CMD [ "/usr/bin/bash" ]
