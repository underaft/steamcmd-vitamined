#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh
. /opt/underaft/lib/validations.sh

sync_folders() {
    local src="${1}"
    local dst="${2}"
    local OVERWRITE_SYNC="${3:-false}"
    if [[ -z "${src}" || -z "${dst}" ]]; then
        err "sync_folders: requires <src> and <dst> arguments"
        return 1
    fi

    if [[ ! -d "${src}" ]]; then
        debug "sync_folders: source directory not found: ${src}"
        return 0
    fi

    if [[ ! -d "${dst}" ]]; then
        debug "sync_folders: dest directory not found: ${dst}"
        return 0
    fi

    create_directories "${dst}"

    # Normalize: remove any trailing slashes, then add exactly one.
    src="${src%/}/"
    dst="${dst%/}/"

    info "Syncing ${src} into ${dst}"

    if is_true "${OVERWRITE_SYNC:-}"; then
      rsync -av "${src}" "${dst}"
    else
      rsync -av --update "${src}" "${dst}"
    fi

}

apply_perms() {
  local uid="${1}" gid="${2}" target="${3}"
  chown -R "${uid}:${gid}" "${target}"
}
create_directories() {
  local uid="${USER_ID}" gid="${USER_ID}"

  if is_int "${1:-}"; then
    uid="${1}"
    gid="${1}"
    if is_int "${2:-}"; then
      gid="${2}"
      shift
    fi
    shift
  fi


  for path in "$@"; do
    [[ ! -d "${path}" ]] && mkdir -p "${path}"
    apply_perms "${uid}" "${gid}" "${path}"
  done
}