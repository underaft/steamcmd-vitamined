---
title: Filesystem and volumes
description: Persistence, ownership, and host/container volume mapping.
---

# Filesystem and volumes

Volume setup controls whether game state, logs, and backups survive container restarts and upgrades. If mounts are missing or misconfigured, the container may run but data can be lost, or writes can fail with permission errors.

## Host ↔ container path mapping

| Purpose | Container Path | Host Mount | Notes |
|---------|----------------|------------|-------|
| Game data | `${GAME_SERVER_BASE_DIR}` | `./data:/home/steam/server` | Persistent saves |
| Logs | `${LOGS_BASE_DIR}` | `./logs:/home/steam/logs` | Server logs |
| Backups | `${BACKUPS_BASE_DIR}` | `./backups:/home/steam/backups` | Backups |
| Custom files | `${CUSTOM_FILES_DIR}` | `./custom:/underaft` | Config overrides |
| Game layer | `${UFT_GAME_DIR}` | Volume or in-image | Game-specific code |

## Folder lifecycle

### Shipped paths (in the image)

- `/opt/underaft/lib`
- `/opt/underaft/scripts`

### Runtime-created paths (by `bootstrap.sh`)

- `HOME` (default `/home/steam`)
- Logs directory (`${LOGS_BASE_DIR}`)
- Backups directory (`${BACKUPS_BASE_DIR}`)
- Custom files directory (`${CUSTOM_FILES_DIR}`, default `/underaft`)

### Externally-supplied paths (you provide)

- Game layer at `${UFT_GAME_DIR}`

## Permission model

- `USER_ID` and `USER_NAME` control the runtime user.
- Defaults are `USER_ID=1000` and `USER_NAME=steam`.
- Runtime-created directories are created/chowned for this user ID.
- Host-mounted directories must be writable by this UID, or startup/runtime writes can fail.

## Example `docker-compose` volume mounts

```yaml
services:
  steamcmd-vitamined:
    volumes:
      - ./game-data:/home/steam/server
      - ./logs:/home/steam/logs
      - ./backups:/home/steam/backups
      - ./custom:/underaft
```

## Data flow diagram

```text
Host Machine                    Container
+------------------+            +------------------+
| ./game-data      |----------->| /home/steam/     |
| (persistent)     |   mount    |   server         |
+------------------+            +------------------+
| ./logs           |----------->| /home/steam/logs |
+------------------+            +------------------+
| ./backups        |----------->| /home/steam/     |
+------------------+            |   backups        |
| ./custom         |----------->| /underaft        |
+------------------+            +------------------+
```

## Important notes

- `configs/` is declared in `glob-env.sh` (`UFT_CONFIGS_DIR`) but is **not** shipped in the image.
- `UFT_GAME_DIR` defaults to `/opt/underaft/${GAME_SERVER_NAME}`.
- `GAME_SERVER_BASE_DIR` is `${HOME}/${GAME_SERVER_NAME}` for persistent game data.

## Related docs

- [Configuration](./configuration.md) for environment variable controls.
- [Runtime layout](../reference/runtime-layout.md) for the full path inventory.

---

**Navigation:** [Docs home](../index.md)
