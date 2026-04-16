---
title: Runtime modes
description: Base mode and game mode behavior at container startup.
---

# Runtime modes

This image has two runtime modes. The mode is selected by `GAME_SERVER_NAME`.

## Base Mode

**Trigger:** `GAME_SERVER_NAME` is unset or empty.

**Behavior:** the container executes:

```bash
exec "${@}"
```

This passes control directly to the command you provide.

**Use cases:**
- Running SteamCMD directly
- Debugging startup behavior
- Inspecting the image/runtime environment

**Example:**

```bash
docker compose run --rm steamcmd-vitamined steamcmd +quit
```

> Important: If you do not provide a command in base mode, the container exits immediately.

## Game Mode

**Trigger:** `GAME_SERVER_NAME` is set (for example, `GAME_SERVER_NAME=valheim`).

**Required file:**

`\${UFT_GAME_DIR}/scripts/entrypoint.sh`

**Behavior:**
- Container startup delegates execution to the game entrypoint script.
- `\${UFT_GAME_DIR}/bin` is prepended to `PATH` before mode dispatch.
- You can optionally provide `/opt/underaft/lib/\${GAME_SERVER_NAME}.sh` as a welcome-page hook.

## Base vs Game mode comparison

| Aspect | Base Mode | Game Mode |
|--------|-----------|-----------|
| `GAME_SERVER_NAME` | Unset | Set |
| Required files | None | `entrypoint.sh` |
| Command handling | Passthrough | Delegated to entrypoint |
| PATH mutation | No | Yes (`bin/` prepended) |
| Use case | Debugging, SteamCMD | Running game servers |

## Failure case: missing game entrypoint

If `GAME_SERVER_NAME` is set but `\${UFT_GAME_DIR}/scripts/entrypoint.sh` is missing, startup fails and the container exits with an error. The failure is tied to the required game entrypoint path (`\${UFT_GAME_DIR}/scripts/entrypoint.sh`).

## Decision flow

```text
Start Container
     |
     v
GAME_SERVER_NAME set?
     |
   /   \
 No     Yes
 |        |
 v        v
Base     Check for
Mode     entrypoint.sh
|            |
|          /   \
|       Found  Missing
|        |        |
|        v        v
|     Game     Error/
|     Mode     Exit
v
exec "${@}"
```

## Related pages

- [Extending for games](../extend/extending-for-games.md) — how to create and package game-mode files
- [Runtime contract](../extend/runtime-contract.md) — game entrypoint contract details
- [Troubleshooting](../troubleshooting.md) — mode-related diagnostics

---

**Navigation:** [Docs home](../index.md)
