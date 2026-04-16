# Repository Guidelines

## Project Structure & Module Organization
- Root assets live in `Dockerfile`, `docker-compose.yaml`, and `release.sh`; images build the `steamcmd-vitamined-final` target from the SteamCMD Debian base.
- Runtime artifacts reside under `rootfs/opt/underaft/`: `lib/` holds shared bash helpers (logging, env, filesystem, validation), `scripts/` contains `bootstrap.sh` (user/setup) and `entrypoint.sh` (runtime dispatch), and game-specific assets mount into `${UFT_GAME_DIR}` (defaults to `/opt/underaft/server`).
- Persistent data, backups, logs, and custom overrides are expected under `${HOME}` and `/underaft` at runtime; ensure volumes map these paths when composing services.

## Build, Test, and Development Commands
- `docker compose build` — build the image locally (honors `REGISTRY_URL`, `RELEASE_VERSION`, and `USER_ID` build arg).
- `docker compose up -d` — start the base container; default command `wait_forever` leaves the container idle for interactive debugging.
- `./release.sh build` — helper to build with interactive version bumping; `./release.sh push` pushes built tags with `docker compose push`.
- Manual smoke: `docker compose run --rm steamcmd-vitamined steamcmd +quit` verifies SteamCMD is reachable in the image.

## Coding Style & Naming Conventions
- Shell scripts use `bash`, `set -euo pipefail`, and lowercase snake_case functions (`ensure_user`, `sync_folders`). Keep shebangs and `shellcheck`-friendly patterns.
- Reuse logging helpers (`info`, `warn`, `err`, `debug`) and environment accessors from `glob-env.sh`; configuration variables remain uppercase (e.g., `GAME_SERVER_NAME`, `LOG_LEVEL`).
- Maintain idempotent setup in `bootstrap.sh` and separation between library code in `lib/` and orchestration in `scripts/`.

## Testing Guidelines
- No dedicated automated suite is present; prefer adding focused script-level tests (e.g., `shellcheck rootfs/opt/underaft/lib/*.sh`) and container smoke checks before PRs.
- When adding game modules, include a minimal `scripts/entrypoint.sh` under the module directory and verify it runs via `docker compose run` with `GAME_SERVER_NAME` set.

## Commit & Pull Request Guidelines
- Use concise commit subjects in imperative mood ("Add entrypoint logging", "Fix wait loop") and group related changes per commit.
- PRs should describe intent, notable env vars, and runtime testing performed; include logs from a smoke run or build output when relevant.

## Security & Configuration Tips
- Keep `USER_ID`/`USER_NAME` aligned with host mappings to avoid permission drift on mounted volumes.
- Avoid baking secrets into the image; rely on env vars or mounted files. Set `PRINT_WELCOME_PAGE=false` or `LOG_LEVEL=debug` only when needed.
- Before publishing, run `find / -perm /6000 -type f -exec chmod a-s {} \;` or reuse the Dockerfile stage to ensure suid bits are stripped.
