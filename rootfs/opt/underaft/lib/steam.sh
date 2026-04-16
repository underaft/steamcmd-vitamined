#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

install_steam_game() {
  local app_id="${1}" install_dir="${2:-"${GAME_SERVER_BASE_DIR:-}"}"
  if [[ -z "${2:-}" ]]; then
    shift
  fi
  shift
  local manifest_file="${install_dir}/steamapps/appmanifest_${app_id}.acf"
  if [[ -f "${manifest_file}" ]]; then
    info "Cleaning up ${manifest_file}"
    rm "${manifest_file}"
  fi
  steamcmd +force_install_dir "${install_dir}" \
    +login anonymous \
    +app_update "${app_id}" \
    +quit \
    validate "${@}"
}

if [[ "${1:-}" == "install" ]]; then
  install_steam_game "${STEAMAPPID}"
fi