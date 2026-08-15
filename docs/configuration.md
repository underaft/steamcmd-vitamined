# Configuration

## Operator variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `GAME_SERVER_NAME` | unset | Selects game mode and the game layer name |
| `IMAGE_REF` | `steamcmd-vitamined:latest` | Complete local Compose image reference |
| `LOG_LEVEL` | `info` | `error`, `warn`, `info`, or `debug` |
| `PRINT_WELCOME_PAGE` | `true` | Show the startup banner |
| `SCRIPT_DEBUG` | `false` | Enable Bash tracing in runtime scripts |
| `CUSTOM_FILES_DIR` | `/underaft` | Operator-supplied override directory |
| `USER_NAME` | `steam` | Image build/runtime user name |
| `USER_ID` | `1000` | Image build/runtime user ID |

## Derived paths

| Variable | Derivation |
| --- | --- |
| `UFT_INSTALL_DIR` | `/opt/underaft` |
| `UFT_GAME_DIR` | `/opt/underaft/${GAME_SERVER_NAME:-server}` |
| `GAME_SERVER_BASE_DIR` | `${HOME}/${GAME_SERVER_NAME:-server}` |
| `LOGS_BASE_DIR` | `${HOME}/logs` |
| `BACKUPS_BASE_DIR` | `${HOME}/backups` |

Set `USER_ID` to the host UID used for mounted directories. The current Compose file passes a fixed build argument, while the Dockerfile defaults the image environment to `1000`; do not assume a runtime environment override changes the already-created user.

## Persistence

Mount these paths when data must survive container replacement:

```text
./game-data -> /home/steam/<game>
./logs      -> /home/steam/logs
./backups   -> /home/steam/backups
./custom    -> /underaft
```

The mounted directories must be writable by the runtime UID.
