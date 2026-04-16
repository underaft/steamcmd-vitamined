---
title: Runtime layout
description: Runtime path map showing shipped, declared, and runtime-created locations.
---

# Runtime layout

This page answers: **"What is actually in the image, and where do things go at runtime?"**

Understanding this layout helps you set volume mounts correctly and debug missing paths quickly.

## In-image layout (`/opt/underaft`)

```text
/opt/underaft/
├── lib/                          # SHIPPED - Helper libraries
│   ├── box_info.sh               # Welcome page rendering
│   ├── fs.sh                     # Filesystem operations
│   ├── glob-env.sh               # Path definitions
│   ├── log.sh                    # Logging functions
│   ├── os.sh                     # OS utilities
│   ├── requests.sh               # HTTP downloads
│   ├── steam.sh                  # SteamCMD wrapper
│   ├── underaft.sh               # Welcome logic
│   └── validations.sh            # Validation helpers
├── scripts/                      # SHIPPED - Runtime scripts
│   ├── bootstrap.sh              # Build-time setup
│   └── entrypoint.sh             # Container entrypoint
├── configs/                      # RESERVED - Declared but NOT shipped
│   └── (empty - reserved for future use)
└── ${GAME_SERVER_NAME:-server}/  # GAME-SUPPLIED - Your game layer
    ├── scripts/
    │   └── entrypoint.sh         # REQUIRED
    └── bin/                      # OPTIONAL
```

## Runtime-created layout (`${HOME}`)

```text
${HOME} (default: /home/steam)
├── ${GAME_SERVER_NAME:-server}/  # RUNTIME-CREATED - Game data
│   └── (game saves, configs)
├── backups/                      # RUNTIME-CREATED - Backups
└── logs/                         # RUNTIME-CREATED - Log files
```

## Path classification

| Path | Category | Notes |
|------|----------|-------|
| `/opt/underaft/lib/` | Shipped | Helper libraries |
| `/opt/underaft/scripts/` | Shipped | Bootstrap and entrypoint |
| `/opt/underaft/configs/` | Declared only | Defined in `glob-env.sh` but not created |
| `${UFT_GAME_DIR}/` | Game-supplied | You provide this |
| `${HOME}/` | Runtime-created | Created by `bootstrap.sh` |
| `/underaft` | Runtime-created | Custom files dir (`CUSTOM_FILES_DIR`) |

## Host ↔ container path reference

| Purpose | Container Path | Typical Host Mount |
|---------|----------------|-------------------|
| Game data | `/home/steam/${GAME_SERVER_NAME}` | `./data` |
| Logs | `/home/steam/logs` | `./logs` |
| Backups | `/home/steam/backups` | `./backups` |
| Custom files | `/underaft` | `./custom` |
| Game layer | `/opt/underaft/${GAME_SERVER_NAME}` | `./game-layer` (or in-image) |

## Environment variables that affect layout

- `GAME_SERVER_NAME` — Changes `${GAME_SERVER_NAME:-server}` paths.
- `HOME` — Base for persistent data (default: `/home/steam`).
- `CUSTOM_FILES_DIR` — Custom files location (default: `/underaft`).

## Related docs

- [Filesystem and volumes](../run/filesystem-and-volumes.md) for mount examples.
- [Environment reference](./environment-reference.md) for all variables.

---

**Navigation:** [Docs home](../index.md)
