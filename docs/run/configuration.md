---
title: Configuration
description: Operator-facing environment variables and what to change safely.
---

# Configuration

Container behavior is configured through environment variables. This page shows the main operator-facing knobs, what each one controls, and which values are usually safe to change.

## Configuration groups

### Group 1: Identity

| Variable | Default | Description |
|----------|---------|-------------|
| `GAME_SERVER_NAME` | (unset) | Enables game mode, names the game layer |
| `USER_NAME` | `steam` | Runtime user name (build-time) |
| `USER_ID` | `1000` | Runtime user ID (build-time) |

### Group 2: Logging

| Variable | Default | Description |
|----------|---------|-------------|
| `LOG_LEVEL` | `info` | Verbosity: `error`, `warn`, `info`, `debug` |
| `PRINT_WELCOME_PAGE` | `true` | Show startup info banner |

### Group 3: Paths

| Variable | Default | Description |
|----------|---------|-------------|
| `CUSTOM_FILES_DIR` | `/underaft` | Path for custom config overrides |

### Group 4: Debug

| Variable | Default | Description |
|----------|---------|-------------|
| `SCRIPT_DEBUG` | `false` | Enable bash trace mode (`set -x`) |

### Group 5: Cosmetic/Internal (generally don't change)

| Variable | Default | Description |
|----------|---------|-------------|
| `UFT_MODULE_NAME` | `UnderAFT` | Log prefix label |
| `DISABLE_BOX_RENDERING` | `false` | Disable welcome box borders |
| `LOG_BOX_INNER_WIDTH` | `60` | Welcome box width |

## Safe to change vs derived vs internal

| Classification | Variables | Guidance |
|----------------|-----------|----------|
| Safe to change | `GAME_SERVER_NAME`, `LOG_LEVEL`, `PRINT_WELCOME_PAGE`, `CUSTOM_FILES_DIR`, `SCRIPT_DEBUG` | Configure these for your needs |
| Build-time only | `USER_NAME`, `USER_ID` | Set at build, not runtime |
| Derived paths | `UFT_*`, `GAME_SERVER_BASE_DIR`, `BACKUPS_BASE_DIR`, `LOGS_BASE_DIR` | Computed from other values, don't set directly |
| Internal | `UFT_MODULE_NAME`, `DISABLE_BOX_RENDERING`, `LOG_BOX_INNER_WIDTH` | Cosmetic, rarely need changing |

## `GAME_SERVER_NAME` cascade effect

```text
GAME_SERVER_NAME=valheim
     |
     +---> UFT_GAME_DIR=/opt/underaft/valheim
     +---> GAME_SERVER_BASE_DIR=/home/steam/valheim
     |
     +---> Looks for entrypoint at:
     |     /opt/underaft/valheim/scripts/entrypoint.sh
     |
     +---> Adds to PATH:
           /opt/underaft/valheim/bin
```

## Related docs

- [Environment reference](../reference/environment-reference.md) for the exhaustive variable list.
- [Runtime modes](./runtime-modes.md) for `GAME_SERVER_NAME` mode-switch behavior.

---

**Navigation:** [Docs home](../index.md)
