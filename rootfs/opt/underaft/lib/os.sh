#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh

redirect_log_to_stdout() {
  ln -sf /proc/1/fd/1 "${1}"
}

wait_forever() {
  set -m  # ensure job control is enabled
  trap 'echo "Received SIGTERM"; exit 0' SIGTERM
  trap 'echo "Received SIGINT"; exit 0' SIGINT
  trap 'echo "Received SIGHUP"; exit 0' SIGHUP
  trap 'echo "Received SIGQUIT"; exit 0' SIGQUIT
  trap 'echo "Cleaning up before exit"; kill 0; exit 0' EXIT

  local sleep_time="${1:-60}"
  shift || true

  if [[ $# -gt 0 ]]; then
    debug "Running task: ${*}"
    "$@"
  fi

  info "Container is now idle and waiting. Press Ctrl+C or stop the container to exit."
  while true; do
    sleep "${sleep_time}" &
    wait ${!}
  done
}