#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

install_steam_game() {
  local app_id="${1:?missing Steam app id}" install_dir="${2:-"${GAME_SERVER_BASE_DIR:-}"}"
  if [[ $# -ge 2 ]]; then
    shift 2
  else
    shift
  fi

  local manifest_file="${install_dir}/steamapps/appmanifest_${app_id}.acf"
  if [[ -f "${manifest_file}" ]]; then
    info "Cleaning up ${manifest_file}"
    rm "${manifest_file}"
  fi

  local -a extra_args=()
  if [[ -n "${STEAMCMD_EXTRA_ARGS:-}" ]]; then
    read -r -a extra_args <<< "${STEAMCMD_EXTRA_ARGS}"
  fi
  extra_args+=("${@}")

  steamcmd +force_install_dir "${install_dir}" \
    +login anonymous \
    +app_update "${app_id}" \
    "${extra_args[@]}" \
    validate \
    +quit
}

if [[ "${1:-}" == "install" ]]; then
  install_steam_game "${STEAMAPPID}"
fi
