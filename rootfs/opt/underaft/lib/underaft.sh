#!/bin/bash

# Load Libraries
. /opt/underaft/lib/log.sh
. /opt/underaft/lib/box_info.sh

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

print_welcome_page() {
  print_box_header
  print_box_text_centered "UNDER/AFT"
  print_box_text_centered "Unified Deployment & Environment Runtime"
  print_box_text_centered "Automated Framework Technology"
  print_box_text_centered "https://underaft.com"
  print_box_footer

  if [[ -n "${GAME_SERVER_NAME:-}" ]]; then
    local game_lib="${UFT_LIBS_DIR}/${GAME_SERVER_NAME}.sh"
    if [[ -f "${game_lib}" ]]; then
      (
        # shellcheck disable=SC1090
        source "${game_lib}"
        if declare -F server_welcome_page >/dev/null 2>&1; then
          server_welcome_page
        fi
      )
    fi
  fi
}