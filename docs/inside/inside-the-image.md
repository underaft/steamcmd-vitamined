---
title: Inside the image
description: Internal lifecycle inside the running container and how core runtime components interact.
---

# Inside the image

This page answers: **What happens inside the container from start to finish?**

Understanding this internal flow makes startup issues easier to debug: you can tell whether a problem is in environment/path setup, welcome rendering, or mode dispatch.

## Lifecycle scope: build-time vs bootstrap-time vs runtime

- **Build-time**: `Dockerfile` assembles the image.
- **Bootstrap-time**: `/opt/underaft/scripts/bootstrap.sh` runs during image build to prepare user/directories and update SteamCMD.
- **Runtime**: `/opt/underaft/scripts/entrypoint.sh` runs when the container starts, sets up runtime behavior, and dispatches into base mode or game mode.

This page focuses on **runtime internals**.

## Library sourcing sequence at runtime

At startup, `entrypoint.sh` sources libraries in this order:

1. `underaft.sh`
2. `validations.sh`
3. `glob-env.sh`

Why each matters:

- `validations.sh`: lightweight helper checks used by runtime decisions (for example, boolean-like value checks).
- `glob-env.sh`: defines shared runtime environment variables, including all `UFT_*` path variables and derived data locations.
- `underaft.sh`: owns welcome-page behavior and optionally loads a game-specific library hook.

## How `glob-env.sh` derives runtime paths

`glob-env.sh` derives most paths from base variables instead of hardcoding per-feature paths.

Path hierarchy:

```text
UFT_INSTALL_DIR (/opt/underaft)
   |
   +-- UFT_SCRIPTS_DIR  -> ${UFT_INSTALL_DIR}/scripts
   +-- UFT_LIBS_DIR     -> ${UFT_INSTALL_DIR}/lib
   +-- UFT_CONFIGS_DIR  -> ${UFT_INSTALL_DIR}/configs
   +-- UFT_GAME_DIR     -> ${UFT_INSTALL_DIR}/${GAME_SERVER_NAME:-server}

PERSISTENT_DATA_DIR (${HOME})
   |
   +-- GAME_SERVER_BASE_DIR -> ${PERSISTENT_DATA_DIR}/${GAME_SERVER_NAME:-server}
   +-- BACKUPS_BASE_DIR     -> ${PERSISTENT_DATA_DIR}/backups
   +-- LOGS_BASE_DIR        -> ${PERSISTENT_DATA_DIR}/logs
```

`GAME_SERVER_NAME` changes both:

- `UFT_GAME_DIR` (in-image game layer lookup)
- `GAME_SERVER_BASE_DIR` (persistent per-game data location)

If `GAME_SERVER_NAME` is unset, both default to a `server` path suffix.

## PATH mutation and command resolution

Before dispatch, `entrypoint.sh` prepends:

- `${UFT_GAME_DIR}/bin`

to `PATH`.

This makes game-specific binaries resolve first, so a game layer can provide its own commands without requiring absolute paths.

## Welcome-page flow and optional game hook

Welcome rendering is controlled by `PRINT_WELCOME_PAGE`:

- truthy -> welcome output is rendered
- falsy -> welcome is skipped

The welcome output includes runtime context such as system details, key paths, and current mode-oriented information.

`underaft.sh` also supports game-specific extension:

- when `GAME_SERVER_NAME` is set, it looks for `${UFT_LIBS_DIR}/${GAME_SERVER_NAME}.sh`
- if present and it defines `server_welcome_page()`, that function is called for custom game output

## Log level behavior

Logging behavior is controlled by two environment variables:

- `LOG_LEVEL`: verbosity threshold (`error`, `warn`, `info`, `debug`)
- `UFT_MODULE_NAME`: log group/prefix label used in emitted log lines

Together, they control both how much you see and which runtime component name appears in each message prefix.

## Internal component interaction diagram

```text
entrypoint.sh
     |
     +---> validations.sh (helpers)
     |
     +---> glob-env.sh (path derivation)
     |       |
     |       +---> UFT_GAME_DIR
     |       +---> GAME_SERVER_BASE_DIR
     |       +---> etc.
     |
     +---> underaft.sh (welcome logic)
     |       |
     |       +---> Optional: game_lib.sh
     |       |       |
     |       |       +---> server_welcome_page()
     |       |
     |       +---> Render welcome
     |
     +---> Update PATH
     |
     +---> Dispatch (game or base mode)
```

## Related pages

- For mode dispatch behavior in detail, see [Runtime modes](../run/runtime-modes.md).
- For implementing `game_lib` and other extension hooks, see [Extending for games](../extend/extending-for-games.md).

---

**Navigation:** [Docs home](../index.md)
