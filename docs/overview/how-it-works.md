---
title: How it works
description: Build-time and runtime flow for the SteamCMD Vitamined image.
---

# How it works

This page answers: **What happens when I build, and what happens when I run?**

Phase 01 audits verified that this project has a two-phase lifecycle:

1. **Build-time**: image assembly and bootstrap execution.
2. **Runtime**: container startup and entrypoint dispatch.

Understanding this split helps troubleshoot whether an issue belongs to image creation or container execution.

## Build-time flow

At build time, the `Dockerfile` starts from `steamcmd/steamcmd:debian`, copies `rootfs/` into the image, and runs `/opt/underaft/scripts/bootstrap.sh`.

```text
Dockerfile
   |
   v
+------------------+
| steamcmd:debian  |
+------------------+
   |
   | COPY rootfs /
   v
+------------------+
| Run bootstrap.sh |
| - Update Steam   |
| - Create user    |
| - Setup dirs     |
+------------------+
   |
   v
Final Image
```

### bootstrap.sh role (build-time)

`bootstrap.sh` runs during image build to do three core tasks:

- Update SteamCMD (`steamcmd +quit`)
- Create the runtime user if missing (`USER_NAME` / `USER_ID`)
- Create required runtime directories (persistent data, logs, backups, custom files)

## Runtime flow

At runtime, the container starts with `/opt/underaft/scripts/entrypoint.sh`. It loads shared libs, optionally prints the welcome page, then dispatches to game mode or base mode.

```text
Container Start
   |
   v
+------------------+
| Source libs      |
| (underaft.sh,    |
|  validations.sh, |
|  glob-env.sh)    |
+------------------+
   |
   v
+------------------+
| Print welcome?   |
| (if enabled)     |
+------------------+
   |
   v
+------------------+
| Dispatch         |
| GAME_SERVER_NAME |
| set?             |
+------------------+
  /              \
Yes              No
/                  \
v                    v
Game Mode          Base Mode
(exec game         (exec "${@}")
 entrypoint)       (exits if no
                    command)
```

### entrypoint.sh dispatch logic

- If `GAME_SERVER_NAME` is set, `entrypoint.sh` executes `${UFT_GAME_DIR}/scripts/entrypoint.sh` (game mode).
- If `GAME_SERVER_NAME` is not set, it executes the provided container command (`exec "${@}"`) in base mode.
- With no command in base mode, startup exits (as verified in Phase 01).

## Related pages

- For internal file layout and shipped components, see [Inside the image](../inside/inside-the-image.md).
- For deeper behavior of base mode vs game mode, see [Runtime modes](../run/runtime-modes.md).

---

**Navigation:** [Docs home](../index.md)
