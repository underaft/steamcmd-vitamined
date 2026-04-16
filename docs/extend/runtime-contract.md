---
title: Runtime contract
description: Exact file-level runtime interface external game assets must satisfy in game mode.
---

# Runtime contract

**Note**: This page documents the runtime contract for operators extending the base image with game layers. It does not cover modifying `steamcmd-vitamined` internals.

## Overview

Game mode is enabled by setting `GAME_SERVER_NAME`. Once enabled, startup expects your external game layer to satisfy a file-level contract under `\${UFT_GAME_DIR}`. An optional welcome hook can also be supplied at `/opt/underaft/lib/${GAME_SERVER_NAME}.sh`. If required files are missing, startup fails.

Path boundary reminder:

- `${UFT_GAME_DIR}` is the operator-supplied extension layer.
- `${GAME_SERVER_BASE_DIR}` is the runtime game install/data path under `${HOME}`.

## Required vs optional file tree

```text
${UFT_GAME_DIR}/                    # Game-layer directory (operator-supplied)
├── scripts/
│   └── entrypoint.sh              # REQUIRED - Must exist and be executable
└── bin/                           # OPTIONAL - Contents added to PATH
    └── (your binaries)

/opt/underaft/lib/                  # Shipped path with optional override hook
└── ${GAME_SERVER_NAME}.sh         # OPTIONAL - Welcome hook library
```

## File requirements

| File | Requirement | Description |
|------|-------------|-------------|
| `${UFT_GAME_DIR}/scripts/entrypoint.sh` | **REQUIRED** | Main entry point, must exist and be executable. Will be exec'd with any remaining arguments. |
| `${UFT_GAME_DIR}/bin/` | Optional | Directory contents are prepended to PATH. Useful for game-specific binaries. |
| `/opt/underaft/lib/${GAME_SERVER_NAME}.sh` | Optional | If exists, sourced at startup. Can define `server_welcome_page` function for custom welcome output. |

## `entrypoint.sh` requirements

- Must exist as a regular file.
- Should be executable (`chmod +x`).
- Will be executed via `exec`, replacing the entrypoint process.
- Receives any command-line arguments passed to the container.
- Should use `set -euo pipefail` for safety.
- Can source helper libraries from `${UFT_LIBS_DIR}/`.

## `bin/` directory behavior

- `${UFT_GAME_DIR}/bin` is prepended to `PATH`.
- Any executables here can be called by name.
- Useful for game server binaries, wrapper scripts, and launch helpers.

## Welcome hook (optional)

To extend welcome output:

1. Create `/opt/underaft/lib/${GAME_SERVER_NAME}.sh`.
2. Define a function named `server_welcome_page()`.
3. During startup welcome rendering, this function is called if defined.

Use this for game-specific runtime details in the startup banner.

## Startup failure modes

| Condition | Error | Result |
|-----------|-------|--------|
| Missing entrypoint.sh | "NO GAME ENTRYPOINT FOUND" | Exit code 1 |
| Wrong GAME_SERVER_NAME | Looks in wrong UFT_GAME_DIR | Entrypoint not found |
| Non-executable entrypoint | Permission denied / execution failure | Startup fails (exact message not yet verified in this audit) |

## Error message reference

- **"NO GAME ENTRYPOINT FOUND"**: `${UFT_GAME_DIR}/scripts/entrypoint.sh` does not exist. Check `GAME_SERVER_NAME` and ensure the file is present.

## Related pages

- For extension examples and packaging approaches, see [Extending for games](./extending-for-games.md).
- For startup diagnostics, see [Troubleshooting](../troubleshooting.md).

---

**Navigation:** [Docs home](../index.md)
