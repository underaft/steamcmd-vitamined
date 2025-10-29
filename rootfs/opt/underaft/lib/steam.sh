#!/usr/bin/env bash

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

install_steam_game() {
  local app_id="${1}" install_dir="${2:-"${GAME_SERVER_BASE_DIR:-}"}"
  if [[ -z "${2:-}" ]]; then
    shift
  fi
  shift
  steamcmd +force_install_dir "${install_dir}" \
    +login anonymous \
    +app_update "${app_id}" \
    +quit \
    validate "${@}"
}

if [[ "${1:-}" == "install" ]]; then
  install_steam_game "${STEAMAPPID}"
fi