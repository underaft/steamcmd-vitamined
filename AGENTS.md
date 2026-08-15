# Repository Guide

SteamCMD Vitamined is an UnderAft base image for SteamCMD-backed game servers. Keep this repository small: shared runtime behavior belongs in `rootfs/opt/underaft`, operator guidance belongs in `README.md` and `docs/`, and automation belongs in `.github/` plus `release.sh`.

## Before changing anything

```bash
git status --short
./release.sh check
```

The full check requires Docker, Docker Compose v2, SteamCMD network access, and ShellCheck. It builds locally, runs the SteamCMD smoke test, and exercises base mode, empty-command startup, and missing-game-entrypoint behavior.

## Repository layout

```text
Dockerfile                 image build and runtime user setup
docker-compose.yaml        local image name and Compose service
release.sh                 local check, build, version, and tag commands
rootfs/opt/underaft/       files copied into the image
  lib/                     shared Bash helpers
  scripts/                 bootstrap and runtime dispatch
tests/                     small host-side CLI checks
.github/workflows/         validation, publishing, and release automation
docs/                      human-facing project documentation
```

Game-specific files are intentionally outside this repository. A game layer must provide `${UFT_GAME_DIR}/scripts/entrypoint.sh` when `GAME_SERVER_NAME` is set.

## Local commands

```bash
./release.sh check
./release.sh build steamcmd-vitamined:dev
./release.sh version 1.2.3
./release.sh release 1.2.3
```

`release` never pushes a Git ref or image. Push a release tag only after reviewing the local check output.

## Shell conventions

- Use Bash with `set -euo pipefail`.
- Use lowercase `snake_case` functions and uppercase environment variables.
- Reuse `info`, `warn`, `err`, `debug`, and helpers already under `/opt/underaft/lib`.
- Keep bootstrap idempotent and keep library code separate from orchestration.
- Do not add a dependency when Bash, Docker, or an existing helper already solves the problem.

## Branches and releases

- `next` is the integration branch; normal feature pull requests target it.
- `main` is stable; release tags are plain semver (`1.2.3`) created from it.
- `next` publishes the mutable `latest` image.
- Semver tags publish immutable release images.
- Hotfixes merged into `main` must also be brought back into `next`.

Do not push, force-push, rewrite history, or change GitHub repository settings unless the user explicitly asks for that action. The history reconstruction is deliberately the final local step.
