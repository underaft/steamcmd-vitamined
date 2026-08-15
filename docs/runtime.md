# Runtime behavior

## Modes

| Mode | Trigger | Result |
| --- | --- | --- |
| Base | `GAME_SERVER_NAME` empty | Executes the supplied command directly |
| Game | `GAME_SERVER_NAME=name` | Executes `/opt/underaft/name/scripts/entrypoint.sh` |

Base mode does not invent a long-running command. This is intentional: an operator must choose the process that should own the container.

## Derived paths

```text
GAME_SERVER_NAME=mygame
        |
        +--> UFT_GAME_DIR=/opt/underaft/mygame
        +--> GAME_SERVER_BASE_DIR=/home/steam/mygame
        +--> PATH begins with /opt/underaft/mygame/bin
```

With no game name, the derived game directory is `/opt/underaft/server`, while base mode still runs the supplied command.

## Startup hooks

- `PRINT_WELCOME_PAGE=true` prints the UnderAft banner.
- `/opt/underaft/lib/<game>.sh` may define `server_welcome_page` for a game-specific banner.
- `${UFT_GAME_DIR}/bin` is added to `PATH` before dispatch.
- Missing game entrypoints produce an error and a non-zero exit.
