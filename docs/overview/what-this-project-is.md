---
title: What this project is
description: Plain-language overview of what SteamCMD Vitamined provides, and what you still need to bring.
---

# What this project is

`steamcmd-vitamined` is a base image for running SteamCMD-based game servers with a shared UnderAFT runtime layer on top. It is built from `steamcmd/steamcmd:debian` and adds common startup logic, paths, and helper behavior. In practice, it gives you a stable framework under `/opt/underaft` that your game-specific layer plugs into.

## Mental model

```text
+------------------+     +------------------+     +------------------+
|  Base Image      |     |  Game Layer      |     |  Your Data       |
|  (steamcmd-      |  +  |  (entrypoint.sh  |  +  |  (persistent     |
|   vitamined)     |     |   + game files)  |     |   saves/configs) |
+------------------+     +------------------+     +------------------+
```

Think of this project as the middle piece between SteamCMD itself and your actual game server assets.

## Key terminology

- **UnderAFT**: The runtime layer/framework shipped inside the image.
- **Base mode**: Startup path when `GAME_SERVER_NAME` is not set. The container runs the command it was given; with no command, it exits by default.
- **Game mode**: Startup path when `GAME_SERVER_NAME` is set. The runtime expects and runs `${UFT_GAME_DIR}/scripts/entrypoint.sh`.
- **UFT paths**: Internal runtime paths under `/opt/underaft` (for example `lib/` and `scripts/`).
- **UFT_GAME_DIR**: The folder where game-specific runtime code is expected (defaults to `/opt/underaft/server` when no game name is set).

## What this is NOT

- It is **not** a complete game server on its own.
- It is **not** a one-click deploy solution.
- It does **not** include game files for you.

## Next steps

- For runtime behavior details, read [How it works](./how-it-works.md).
- To begin operating it, read [Quickstart](../run/quickstart.md).

---

**Navigation:** [Docs home](../index.md)
