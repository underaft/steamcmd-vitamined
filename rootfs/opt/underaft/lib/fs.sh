#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh
. /opt/underaft/lib/validations.sh

sync_folders() {
    local src="${1}"
    local dst="${2}"

    if [[ -z "${src}" || -z "${dst}" ]]; then
        err "sync_folders: requires <src> and <dst> arguments"
        return 1
    fi

    if [[ ! -d "${src}" ]]; then
        debug "sync_folders: source directory not found: ${src}"
        return 0
    fi

    create_directories "${dst}"

    # -R: recursive
    # -p: preserve mode/ownership/timestamps
    # -u: copy only when source is newer or missing in destination
    # -f: force overwrite
    # -v: verbose (optional)
    cp -aRTf "${src}" "${dst}"
    debug "Copied ${src} to ${dst}"
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