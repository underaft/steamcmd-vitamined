# Reference

## Image layout

```text
/opt/underaft/
├── lib/       shared helpers
└── scripts/   bootstrap.sh and entrypoint.sh

/home/steam/
├── <game>/    persistent game data
├── logs/      server logs
└── backups/   backups

/underaft/     custom operator files
```

`UFT_CONFIGS_DIR` is reserved by the environment helper but no `/opt/underaft/configs` directory is shipped by this base image.

## Commands

| Command | Use |
| --- | --- |
| `./release.sh check` | Full local validation |
| `./release.sh build [ref]` | Build a local image |
| `./release.sh version X.Y.Z` | Validate a plain semver version |
| `./release.sh release X.Y.Z` | Validate, build, and create a local tag |
| `IMAGE_REF=... docker compose run --rm ...` | Run an explicit container command |

## Environment classification

- Operator-controlled: `GAME_SERVER_NAME`, `LOG_LEVEL`, `PRINT_WELCOME_PAGE`, `SCRIPT_DEBUG`, `CUSTOM_FILES_DIR`, `IMAGE_REF`.
- Build identity: `USER_NAME`, `USER_ID`.
- Derived/internal: `UFT_*`, `HOME`, `PERSISTENT_DATA_DIR`, `GAME_SERVER_BASE_DIR`, `LOGS_BASE_DIR`, `BACKUPS_BASE_DIR`.
