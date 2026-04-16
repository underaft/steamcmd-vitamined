---
title: SteamCMD Vitamined Operator Docs
description: Landing page for running and extending the SteamCMD Vitamined base image for game servers.
---

# SteamCMD Vitamined

This project is a **base image** for SteamCMD-based game servers. It provides shared startup, environment, and helper behavior.

It is **not** a complete game server by itself. You must provide game-specific runtime content for game mode.

## Startup flow at a glance

```text
Container starts
   |
   v
/opt/underaft/scripts/entrypoint.sh
   |
   +--> GAME_SERVER_NAME set?
         |
         +--> No (Base mode)
         |      |
         |      +--> exec "$@"
         |             |
         |             +--> no command args -> container exits
         |
         +--> Yes (Game mode)
                |
                +--> require ${UFT_GAME_DIR}/scripts/entrypoint.sh
                       |
                       +--> run game entrypoint
```

## What operators should know first

- If `GAME_SERVER_NAME` is **not** set, the container runs in base mode and executes the provided command.
- With no command arguments, base mode exits (it does not idle by default).
- Game mode requires:
  - `GAME_SERVER_NAME`
  - `${UFT_GAME_DIR}/scripts/entrypoint.sh`
- Main runtime paths:
  - `UFT_GAME_DIR` for game layer lookup (`/opt/underaft/${GAME_SERVER_NAME:-server}`)
  - `${HOME}` for persistent data
  - `/underaft` for custom supplied files

## Primary reading path

1. [Quickstart](./run/quickstart.md)
2. [Runtime modes](./run/runtime-modes.md)
3. [Filesystem and volumes](./run/filesystem-and-volumes.md)

## Internals track

- [Inside the image](./inside/inside-the-image.md)

## Extension track

- [Extending for games](./extend/extending-for-games.md)
- [Runtime contract](./extend/runtime-contract.md)
- [Helper capabilities](./extend/helper-capabilities.md)

## Reference

- [Runtime layout](./reference/runtime-layout.md)
- [Command reference](./reference/command-reference.md)
- [Environment reference](./reference/environment-reference.md)
- [Troubleshooting](./troubleshooting.md)
- [Known issues](./known-issues.md)

---

**Navigation:** Start with [Quickstart](./run/quickstart.md) · Need internals? [Inside the image](./inside/inside-the-image.md) · Building your own game layer? [Extending for games](./extend/extending-for-games.md)
