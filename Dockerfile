FROM steamcmd/steamcmd:debian-bookworm AS steamcmd-vitamined-base
# Default timezone configuration
ENV LANG=en_US.UTF-8 \
    TZ=UTC

# User settings
ENV USER_NAME=steam \
    USER_ID=1000

# SYS
ENV PATH="/opt/underaft/bin:$PATH" \
    LC_ALL="${LANG}"

ENV HOME="/home/${USER_NAME}"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tzdata locales \
        nano \
        wget curl unzip jq \
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

COPY rootfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
RUN chmod g+rwX /opt/underaft
RUN /opt/underaft/scripts/bootstrap.sh

RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

# Final touch
USER ${USER_ID}
WORKDIR ${HOME}

ENTRYPOINT ["/opt/underaft/scripts/entrypoint.sh"]

FROM steamcmd-vitamined-base AS steamcmd-vitamined-final