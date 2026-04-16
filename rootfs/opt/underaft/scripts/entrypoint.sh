#!/bin/bash
set -euo pipefail

# Load Libraries
. /opt/underaft/lib/underaft.sh
. /opt/underaft/lib/validations.sh

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

if [[ "${SCRIPT_DEBUG:-false}" == "true" ]]; then
  set -x
fi

run_game_entrypoint() {
  if [[ -f "${UFT_GAME_DIR}/scripts/entrypoint.sh" ]]; then
    info "** Starting Game Server: ${GAME_SERVER_NAME:-} **"
    exec "${UFT_GAME_DIR}/scripts/entrypoint.sh" "${@}"
  else
    err "NO GAME ENTRYPOINT FOUND IN ${UFT_GAME_DIR}!!"
    exit 1
  fi
}

main() {
  if is_true "${PRINT_WELCOME_PAGE:-"true"}"; then
    print_welcome_page
  fi

  if [[ -n "${GAME_SERVER_NAME:-}" ]]; then
    debug "Running game entrypoint"
    run_game_entrypoint "${@}"
  else
    debug "Running base entrypoint"
    exec "${@}"
  fi
}
export PATH="${UFT_GAME_DIR}/bin:${PATH}"
main "${@}"