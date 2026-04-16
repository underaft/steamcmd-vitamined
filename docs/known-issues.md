---
title: Known issues
description: Verified mismatches and unresolved behaviors, with impact and workarounds.
---

# Known issues

These are verified issues discovered during the documentation audit. Each issue includes impact and workaround.

## Issue 1: Unused compose anchor

**Issue**  
The `x-base` anchor in `docker-compose.yaml` defines `command: wait_forever` and `LANG: es_ES.UTF-8`, but the `steamcmd-vitamined` service does not inherit from this anchor.

**Impact**
- `docker compose up` without a command causes immediate container exit.
- `LANG` environment variable is not set on the service.

**Documentation Stance**
- Quickstart and command-reference explicitly use `docker compose run --rm` with explicit commands.
- Do not rely on default idle behavior.

**Workaround**
- Always provide an explicit command: `docker compose run --rm steamcmd-vitamined bash`.
- Or set `command: wait_forever` in your override compose file.

Source: `docker-compose.yaml`

## Issue 2: Base mode startup without command

**Issue**  
When `GAME_SERVER_NAME` is unset and no command is provided, `entrypoint.sh` executes `exec "${@}"` with empty arguments, causing the container to exit immediately.

**Impact**
- Container appears to "fail" or restart loop.
- No clear error message for this case.

**Documentation Stance**
- Quickstart warns about this and provides explicit command examples.
- Runtime modes clearly documents base mode behavior.

**Workaround**
- Always provide a command in base mode.
- Use `bash` or `steamcmd +quit` for testing.

Source: `rootfs/opt/underaft/scripts/entrypoint.sh`

## Issue 3: USER_ID configurability

**Issue**  
The Dockerfile sets `ENV USER_ID=1000` but does not declare `ARG USER_ID`, so the build arg from compose doesn't affect the image.

**Impact**
- Cannot easily change runtime user ID via build args.
- Volume permission issues may occur if host UID differs.

**Documentation Stance**
- Document current behavior (`USER_ID=1000` fixed).
- Provide volume ownership guidance in troubleshooting.

**Workaround**
- Ensure host volumes are owned by UID 1000.
- Or build custom image with modified Dockerfile.

Source: `Dockerfile`

## Issue 4: `configs/` directory declared but not shipped

**Issue**  
`glob-env.sh` declares `UFT_CONFIGS_DIR=/opt/underaft/configs`, but no `configs/` directory exists in `rootfs/`.

**Impact**
- Path is reserved but not functional.
- May cause confusion about where configs should go.

**Documentation Stance**
- Runtime-layout notes this as "reserved/declared but absent".
- Use `CUSTOM_FILES_DIR` (`/underaft`) instead.

**Workaround**
- Use `/underaft` for custom configuration files.
- Or mount configs directly to game data directory.

Source: `rootfs/opt/underaft/lib/glob-env.sh`, `docs/reference/runtime-layout.md`

## Issue 5: `docker compose build` fails when `REGISTRY_URL` is unset

**Issue**  
`docker-compose.yaml` defines image as `${REGISTRY_URL}/underaft/steamcmd-vitamined:${RELEASE_VERSION:-latest}`. When `REGISTRY_URL` is unset, Docker Compose defaults it to empty and produces `/underaft/steamcmd-vitamined:latest`, which is an invalid tag.

**Impact**
- `docker compose build` fails before completing image build.
- `docker compose run --rm steamcmd-vitamined steamcmd +quit` also fails before SteamCMD starts.

**Documentation Stance**
- Quickstart and command-reference now call out the `REGISTRY_URL` prerequisite.
- Behavior remains unresolved in compose/image naming; workaround still required.

**Workaround**
- Set a non-empty registry prefix before running compose commands (example: `REGISTRY_URL=local`).
- Or change compose image naming to avoid a leading slash when `REGISTRY_URL` is empty.

Sources: `.orchestrator/tmp/task21/docker-compose-build.log`, `.orchestrator/tmp/task21/docker-compose-smoke.log`, `docker-compose.yaml`

## Related docs

- [Quickstart](./run/quickstart.md)
- [Troubleshooting](./troubleshooting.md)
- [Command reference](./reference/command-reference.md)

---

**Navigation:** [Docs home](./index.md)
