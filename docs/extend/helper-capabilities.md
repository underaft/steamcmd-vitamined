---
title: Helper capabilities
description: Reusable helper libraries game entrypoints can source from the base image.
---

# Helper capabilities

Game entrypoints can source shared helper libraries from the base image via `${UFT_LIBS_DIR}`. Reusing these helpers keeps behavior consistent with the base runtime and reduces duplicated shell logic in game layers.

## Capability families

### Logging (`log.sh`) ✅ Recommended

- Functions: `info`, `warn`, `err`, `debug`
- Controlled by the `LOG_LEVEL` environment variable

```bash
source "${UFT_LIBS_DIR}/log.sh"
info "Starting server installation..."
warn "Config file not found, using defaults"
```

### Filesystem (`fs.sh`) ✅ Recommended

- `create_directories [uid] [gid] paths...` — create directories and apply ownership
- `sync_folders src dst [overwrite]` — sync folders with `rsync`
- `apply_perms uid gid target` — apply recursive ownership permissions

```bash
source "${UFT_LIBS_DIR}/fs.sh"
create_directories 1000 1000 "${GAME_SERVER_BASE_DIR}/config"
sync_folders "/template/config" "${GAME_SERVER_BASE_DIR}/config"
```

### Steam (`steam.sh`) ✅ Recommended

- `install_steam_game app_id [install_dir] [extra_args]`
- Handles SteamCMD login, app update, and validation flow

```bash
source "${UFT_LIBS_DIR}/steam.sh"
install_steam_game 896660 "${GAME_SERVER_BASE_DIR}"
```

### Download/HTTP (`requests.sh`) ✅ Recommended

- `fetch_json url` — fetch JSON with retry behavior
- `download_to_folder folder url [filename]` — download a file into a target folder
- `download_github_asset folder asset url` — fetch a named asset from a GitHub release API response

```bash
source "${UFT_LIBS_DIR}/requests.sh"
download_to_folder "${GAME_SERVER_BASE_DIR}/mods" \
  "https://example.com/mod.zip"
```

## Internal helpers (do not rely on these)

- `box_info.sh` — welcome page rendering internals
- `validations.sh` — internal control-flow helper functions
- `os.sh` — OS/runtime utilities including `wait_forever`

These are implementation details and may change without notice. Do not source them directly from downstream game layers.

## Capability classification

| Capability | Status | Use For |
|------------|--------|---------|
| `log.sh` | ✅ Reliable | All logging needs |
| `fs.sh` | ✅ Reliable | Directory/permission operations |
| `steam.sh` | ✅ Reliable | Steam game installation |
| `requests.sh` | ✅ Reliable | HTTP downloads |
| `box_info.sh` | ⚠️ Internal | Don't use directly |
| `validations.sh` | ⚠️ Internal | Don't use directly |
| `os.sh` | ⚠️ Internal | Don't use directly |

## Helpers vs DIY

- **Use helpers** for logging, Steam installs, file/permission operations, and HTTP downloads.
- **DIY** for game-specific logic, config parsing, and process management.

Helpers provide base-image-consistent behavior, while game-specific orchestration should stay in your entrypoint implementation.

## Related pages

- [Runtime contract](./runtime-contract.md) for where these helpers are used in the extension boundary.
- [Extending for games](./extending-for-games.md) for end-to-end game-layer examples.

---

**Navigation:** [Docs home](../index.md)
