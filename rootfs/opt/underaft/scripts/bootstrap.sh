#!/usr/bin/env bash
set -euo pipefail

# Load Libraries
. /opt/underaft/lib/os.sh
. /opt/underaft/lib/fs.sh

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

if [[ "${SCRIPT_DEBUG:-false}" == "true" ]]; then
  set -x
fi

ensure_user() {
  if ! id -u "${USER_NAME}" >/dev/null 2>&1; then
    info "[bootstrap] Creating user '${USER_NAME}' (uid=${USER_ID}, home=${HOME})"
    useradd -s /bin/bash -u "${USER_ID}" -U "${USER_NAME}" -m -d "${HOME}"
  fi
}

# Update SteamCMD and verify latest version
steamcmd +quit

ensure_user
create_directories "${PERSISTENT_DATA_DIR}" "${LOGS_BASE_DIR}" "${BACKUPS_BASE_DIR}" "${CUSTOM_FILES_DIR}"
