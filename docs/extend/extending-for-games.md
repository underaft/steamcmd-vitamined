---
title: Extending for games
description: How operators can extend the base image with a game-specific runtime layer.
---

# Extending for games

This image is a **base runtime**. To run a real server, you add a **game layer** on top.

Your game layer can provide:

- `scripts/entrypoint.sh` (**required**)
- `bin/` (optional; automatically added to `PATH`)
- `game_lib.sh`-style behavior via `/opt/underaft/lib/${GAME_SERVER_NAME}.sh` (optional)

You can extend the base in two ways:

1. **Volume mount** your game layer (best for development)
2. **Build a derivative image** (best for production)

## Extension model

```text
+------------------+     +------------------+     +------------------+
| steamcmd-        |     | Your Game Layer  |     | Game Assets      |
| vitamined        |  +  | (entrypoint.sh)  |  +  | (Steam install)  |
| (base image)     |     | (bin/)           |     | (saves/configs)  |
+------------------+     +------------------+     +------------------+
        |                        |                        |
        v                        v                        v
+---------------------------------------------------------------+
|                    Running Game Server Container              |
+---------------------------------------------------------------+
```

## Path boundaries for extension work

- `${UFT_GAME_DIR}` (`/opt/underaft/${GAME_SERVER_NAME}`): **operator-supplied extension layer** (`scripts/entrypoint.sh`, optional `bin/`).
- `${GAME_SERVER_BASE_DIR}` (`${HOME}/${GAME_SERVER_NAME}`): **runtime game install/data path** used by game entrypoints.
- `/opt/underaft/lib/${GAME_SERVER_NAME}.sh`: **optional shipped-path hook override** for welcome output only.

## Strategy comparison

| Strategy | Best for | How it works |
| --- | --- | --- |
| Volume mount | Local iteration, testing, quick edits | Mount host `game-layer/` into `${UFT_GAME_DIR}` |
| Derivative image | Repeatable deploys, CI/CD, production | `COPY` game layer into image and ship one artifact |

## Strategy 1: Volume mount (development)

Host layout:

```text
my-game-server/
├── docker-compose.yaml
└── game-layer/
    ├── scripts/
    │   └── entrypoint.sh
    └── bin/
```

`docker-compose.yaml`:

```yaml
services:
  valheim:
    image: underaft/steamcmd-vitamined:latest
    environment:
      GAME_SERVER_NAME: valheim
    volumes:
      - ./game-layer:/opt/underaft/valheim
      - ./data:/home/steam/valheim
```

Workflow:

1. Create `game-layer/scripts/entrypoint.sh`.
2. Set `GAME_SERVER_NAME` (for example: `valheim`).
3. Mount `./game-layer` to `/opt/underaft/${GAME_SERVER_NAME}`.
4. Mount persistent data to `/home/steam/${GAME_SERVER_NAME}`.
5. Start with `docker compose up` (**unverified example**; validate against your own compose stack).

## Strategy 2: Derivative image (production)

`Dockerfile.example`:

```dockerfile
FROM underaft/steamcmd-vitamined:latest

ENV GAME_SERVER_NAME=valheim

# Copy game layer files
COPY game-layer/scripts/entrypoint.sh /opt/underaft/valheim/scripts/
COPY game-layer/bin/ /opt/underaft/valheim/bin/

# Install game via SteamCMD
RUN steamcmd +force_install_dir /home/steam/valheim +login anonymous +app_update 896660 validate +quit
```

> This derivative example is a template and should be validated for your specific game/runtime needs.

Workflow:

1. Add your game layer files under `game-layer/`.
2. `COPY` them into `/opt/underaft/${GAME_SERVER_NAME}`.
3. Optionally pre-install the Steam app during build, targeting `${GAME_SERVER_BASE_DIR}`.
4. Build and run your derivative image.

## Minimum game layer tree

```text
${UFT_GAME_DIR}/
├── scripts/
│   └── entrypoint.sh    # REQUIRED - main entry point
└── bin/
    └── (game binaries)  # OPTIONAL - added to PATH
```

## `entrypoint.sh` skeleton

```bash
#!/bin/bash
set -euo pipefail

# Source the base libraries
source "${UFT_LIBS_DIR}/log.sh"
source "${UFT_LIBS_DIR}/steam.sh"

info "Starting Valheim server..."

# Install/update game
install_steam_game 896660 "${GAME_SERVER_BASE_DIR}"

# Start the server
exec "${GAME_SERVER_BASE_DIR}/valheim_server.x86_64" \
  -name "My Server" \
  -world "MyWorld" \
  -password "secret"
```

## Important boundary

This page is for **operators extending the base image**.

- It is **not** for modifying `steamcmd-vitamined` internals.
- Do **not** modify shipped files in `/opt/underaft/lib/` or `/opt/underaft/scripts/`.
- Optional game hook file `/opt/underaft/lib/${GAME_SERVER_NAME}.sh` is supported only as an added override file (for example via bind mount or derivative image), not by editing shipped base files.

## Related pages

- [Runtime contract](./runtime-contract.md) for required/optional extension files and paths.
- [Helper capabilities](./helper-capabilities.md) for available helper functions.

---

**Navigation:** [Docs home](../index.md)
