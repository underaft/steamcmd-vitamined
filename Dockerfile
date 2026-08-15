FROM steamcmd/steamcmd:debian AS steamcmd-vitamined-base
ARG NODE_MAJOR=25
ARG COREPACK_VERSION=0.34.7
ARG PNPM_VERSION=10.33.0

# Default timezone configuration
ENV LANG=en_US.UTF-8 \
    TZ=UTC

# User settings
ENV USER_NAME=steam \
    USER_ID=1000

# SYS
ENV PNPM_HOME="${HOME}/.local/share/pnpm"
ENV PATH="/opt/underaft/bin:${PNPM_HOME}:${PATH}" \
    LC_ALL="${LANG}"

ENV HOME="/home/${USER_NAME}"
RUN dpkg --add-architecture i386 && apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 python3-pip python3-yaml \
        tzdata locales \
        nano \
        ca-certificates \
        wget curl unzip jq rsync gnupg \
        libcurl4-openssl-dev:i386 \
        libgdiplus libsm6 libxext6 \
        net-tools inetutils-ping traceroute \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable and generate only the most widely used UTF-8 locales
RUN { \
      echo "en_US.UTF-8 UTF-8"; \
      echo "es_ES.UTF-8 UTF-8"; \
      echo "fr_FR.UTF-8 UTF-8"; \
      echo "de_DE.UTF-8 UTF-8"; \
      echo "pt_BR.UTF-8 UTF-8"; \
      echo "ru_RU.UTF-8 UTF-8"; \
      echo "zh_CN.UTF-8 UTF-8"; \
      echo "ja_JP.UTF-8 UTF-8"; \
      echo "ko_KR.UTF-8 UTF-8"; \
      echo "ar_SA.UTF-8 UTF-8"; \
    } > /etc/locale.gen && locale-gen

# Install NodeJS
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/root/.npm \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - && \
    apt-get install -y --no-install-recommends nodejs procps && \
    npm install -g corepack@${COREPACK_VERSION} && \
    corepack enable pnpm && \
    corepack install -g pnpm@${PNPM_VERSION} && \
    rm -rf /var/lib/apt/lists/*

COPY rootfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
RUN chmod g+rwX /opt/underaft
RUN /opt/underaft/scripts/bootstrap.sh

RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

# Final touch
USER ${USER_ID}
WORKDIR ${HOME}

ENTRYPOINT ["/opt/underaft/scripts/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/uft-gsc/steamcmd-vitamined"

FROM steamcmd-vitamined-base AS steamcmd-vitamined-final
