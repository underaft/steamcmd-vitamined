#!/bin/bash

# Global ENV
export UFT_INSTALL_DIR="/opt/underaft"
export UFT_SCRIPTS_DIR="${UFT_INSTALL_DIR}/scripts"
export UFT_LIBS_DIR="${UFT_INSTALL_DIR}/lib"
export UFT_CONFIGS_DIR="${UFT_INSTALL_DIR}/configs"
export UFT_GAME_DIR="${UFT_INSTALL_DIR}/${GAME_SERVER_NAME:-server}"

# Volume Settings
export PERSISTENT_DATA_DIR="${HOME}"
export GAME_SERVER_BASE_DIR="${PERSISTENT_DATA_DIR}/${GAME_SERVER_NAME:-server}"
export BACKUPS_BASE_DIR="${PERSISTENT_DATA_DIR}/backups"
export LOGS_BASE_DIR="${PERSISTENT_DATA_DIR}/logs"

export CUSTOM_FILES_DIR="${CUSTOM_FILES_DIR:=/underaft}"

export UFT_MODULE_NAME="${UFT_MODULE_NAME:-aft}"