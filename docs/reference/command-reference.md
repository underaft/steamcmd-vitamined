---
title: Command reference
description: Exact operator commands, when to run them, and expected outcomes.
---

# Command reference

This page answers: **What commands do I run, and when?**

Use this as a quick command lookup for daily operator workflows.

> Prerequisite: in this repository's current compose setup, set `REGISTRY_URL` to a non-empty value before running compose commands (example: `REGISTRY_URL=local`). See [Known issues](../known-issues.md).

## Operator Commands [Operator]

| Command | Purpose | Environment Variables | Expected Outcome | Status |
|---------|---------|----------------------|------------------|--------|
| `docker compose build` | Build the image | `REGISTRY_URL` must be non-empty | Image build starts successfully | **Verified** |
| `docker compose run --rm steamcmd-vitamined steamcmd +quit` | Smoke test SteamCMD | `REGISTRY_URL` must be non-empty | SteamCMD runs and exits | **Verified** |
| `docker compose run --rm steamcmd-vitamined bash` | Interactive shell | `REGISTRY_URL` must be non-empty | Bash prompt inside container | **Unverified** (example workflow) |
| `docker compose run --rm steamcmd-vitamined <command>` | Run any command | `REGISTRY_URL` must be non-empty | Command executes | **Unverified** (depends on command) |
| `docker compose run --rm -e GAME_SERVER_NAME=valheim steamcmd-vitamined` | Run game mode | `REGISTRY_URL` non-empty, `GAME_SERVER_NAME` required | Fails unless game layer entrypoint exists at `${UFT_GAME_DIR}/scripts/entrypoint.sh` | **Unverified** (requires game layer) |

## Command details

### `docker compose build`
- Builds the image from `Dockerfile`
- Dockerfile sets `USER_ID=1000` via `ENV`; compose `USER_ID` build arg does not currently change this value
- Creates image tags based on `REGISTRY_URL` and `RELEASE_VERSION`
- Requires `REGISTRY_URL` to be set (example: `REGISTRY_URL=local`)

### `docker compose run --rm steamcmd-vitamined steamcmd +quit`
- Verifies SteamCMD is working
- Connects to Steam and updates
- Safe command that exits cleanly
- Requires `REGISTRY_URL` to be set so compose can resolve the image name

### `docker compose run --rm steamcmd-vitamined <command>`
- Base mode: passes command through to the container
- Examples: `bash`, `ls -la /opt/underaft`, `whoami`
- Container exits when the command completes
- Treat command-specific outcomes as unverified unless you validate them in your environment

### Game mode command
- Requires `GAME_SERVER_NAME` environment variable
- Requires game layer files mounted or built in
- If `${UFT_GAME_DIR}/scripts/entrypoint.sh` is missing, startup fails with `NO GAME ENTRYPOINT FOUND`
- Executes `${UFT_GAME_DIR}/scripts/entrypoint.sh` only when the game layer is present

## ⚠️ Important warning

> Do NOT use `docker compose up -d` without a command. The default service has no command configured, so the container will exit immediately. Always use explicit commands with `docker compose run --rm`.

---

**See also:**
- [Quickstart](../run/quickstart.md) for step-by-step setup
- [Known issues](../known-issues.md) for common problems
- [Docs home](../index.md)
