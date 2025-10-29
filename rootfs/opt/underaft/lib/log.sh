#!/usr/bin/env bash

# Load Env Variables
. /opt/underaft/lib/glob-env.sh

# Default log level (error < warn < info < debug)
declare -A _LEVELS=([error]=0 [warn]=1 [info]=2 [debug]=3)

_logger() {
    local group="${UFT_MODULE_NAME:-aft}"
    local log_level="${LOG_LEVEL:-info}"
    local threshold="${_LEVELS[$log_level]:-2}"

    local level="${1}"; shift
    local message="${*}"
    local timestamp prefix line
    local level_value

    case "${level}" in
        error) level_value=0 ;;
        warn)  level_value=1 ;;
        info)  level_value=2 ;;
        debug) level_value=3 ;;
        *)     level_value=2 ;;
    esac

    if (( level_value > threshold )); then
        return 0
    fi

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "${level}" in
        info)    prefix="[i]" ;;
        warn)    prefix="[w]" ;;
        error)   prefix="[e]" ;;
        debug)   prefix="[d]" ;;
        *)       prefix="[?]" ;;
    esac

    line="${timestamp} ${prefix} [${group}] ${message}"

    echo "${line}"
}

info()  { _logger "info"  "$@"; }
warn()  { _logger "warn"  "$@"; }
err()   { _logger "error" "$@"; }
debug() { _logger "debug" "$@"; }
