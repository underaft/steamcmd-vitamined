---
title: Environment reference
description: Exhaustive reference table for all build-time and runtime environment variables.
---

# Environment reference

This is the exhaustive environment-variable reference for this image.

For narrative guidance on what operators should usually change, see [Configuration](../run/configuration.md).

## Master variable table

| Variable | Default | Scope | Category | Source | Description |
|----------|---------|-------|----------|--------|-------------|
| `GAME_SERVER_NAME` | (unset) | Runtime | Identity | `entrypoint.sh` | Enables game mode, names game layer |
| `USER_NAME` | `steam` | Build | Identity | `Dockerfile` | Runtime user name |
| `USER_ID` | `1000` | Build | Identity | `Dockerfile` | Runtime user ID |
| `HOME` | `/home/steam` | Build | Identity | `Dockerfile` | User home directory |
| `REGISTRY_URL` | (blank) | Build | Build | `docker-compose.yaml` | Image registry prefix |
| `RELEASE_VERSION` | `latest` | Build | Build | `docker-compose.yaml` | Image version tag |
| `LOG_LEVEL` | `info` | Runtime | Logging | `log.sh` | Log verbosity: `error`, `warn`, `info`, `debug` |
| `UFT_MODULE_NAME` | `UnderAFT` | Runtime | Logging | `log.sh` | Log prefix label |
| `PRINT_WELCOME_PAGE` | `true` | Runtime | Logging | `entrypoint.sh` | Show startup welcome banner |
| `DISABLE_BOX_RENDERING` | `false` | Runtime | Logging | `box_info.sh` | Disable welcome box borders |
| `LOG_BOX_INNER_WIDTH` | `60` | Runtime | Logging | `box_info.sh` | Welcome box content width |
| `CUSTOM_FILES_DIR` | `/underaft` | Runtime | Paths | `glob-env.sh` | Custom files override directory |
| `UFT_INSTALL_DIR` | `/opt/underaft` | Runtime | Paths | `glob-env.sh` | Base installation directory |
| `UFT_SCRIPTS_DIR` | `/opt/underaft/scripts` | Runtime | Paths | `glob-env.sh` | Scripts directory |
| `UFT_LIBS_DIR` | `/opt/underaft/lib` | Runtime | Paths | `glob-env.sh` | Libraries directory |
| `UFT_CONFIGS_DIR` | `/opt/underaft/configs` | Runtime | Paths | `glob-env.sh` | Config directory (reserved) |
| `UFT_GAME_DIR` | `/opt/underaft/${GAME_SERVER_NAME:-server}` | Runtime | Paths | `glob-env.sh` | Game layer directory |
| `PERSISTENT_DATA_DIR` | `${HOME}` | Runtime | Paths | `glob-env.sh` | Persistent data base |
| `GAME_SERVER_BASE_DIR` | `${HOME}/${GAME_SERVER_NAME:-server}` | Runtime | Paths | `glob-env.sh` | Game data directory |
| `BACKUPS_BASE_DIR` | `${HOME}/backups` | Runtime | Paths | `glob-env.sh` | Backups directory |
| `LOGS_BASE_DIR` | `${HOME}/logs` | Runtime | Paths | `glob-env.sh` | Logs directory |
| `SCRIPT_DEBUG` | `false` | Runtime | Debug | `entrypoint.sh` | Enable bash trace mode |

## Grouped summary

### Identity (Who runs what)

- `GAME_SERVER_NAME`, `USER_NAME`, `USER_ID`, `HOME`

### Build/Tag (Image naming)

- `REGISTRY_URL`, `RELEASE_VERSION`

### Logging (Output control)

- `LOG_LEVEL`, `UFT_MODULE_NAME`, `PRINT_WELCOME_PAGE`, `DISABLE_BOX_RENDERING`, `LOG_BOX_INNER_WIDTH`

### Paths (Where things are)

- `CUSTOM_FILES_DIR` (operator-controlled)
- `UFT_*`, `*_BASE_DIR` (derived)

### Debug (Troubleshooting)

- `SCRIPT_DEBUG`

## Operator vs derived classification

### Operator-Controlled (Safe to change)

- `GAME_SERVER_NAME`, `LOG_LEVEL`, `PRINT_WELCOME_PAGE`, `CUSTOM_FILES_DIR`, `SCRIPT_DEBUG`

### Build-Time Only (Set at build)

- `USER_NAME`, `USER_ID`

### Derived (Computed, don't set directly)

- All `UFT_*` variables, `*_BASE_DIR` variables

### Internal/Cosmetic (Rarely change)

- `UFT_MODULE_NAME`, `DISABLE_BOX_RENDERING`, `LOG_BOX_INNER_WIDTH`

## Related docs

- [Configuration](../run/configuration.md) for narrative guidance on what to change.
- [Runtime layout](./runtime-layout.md) for path locations.

---

**Navigation:** [Docs home](../index.md)
