# How it works

## Build time

```text
steamcmd/steamcmd:debian
          |
          v
       COPY rootfs /
          |
          v
 bootstrap.sh: update SteamCMD, create user, create folders
          |
          v
 final image: non-root user + entrypoint
```

The Dockerfile installs the shared OS tools, copies `/opt/underaft`, runs the idempotent bootstrap script, strips setuid bits, and sets the runtime user and working directory.

## Runtime

`entrypoint.sh` loads the shared libraries and derives paths from environment variables. It optionally prints the UnderAft banner, prepends the game `bin/` directory to `PATH`, and then chooses one execution path:

```text
GAME_SERVER_NAME?
   no  -> exec the command passed to the container
   yes -> exec ${UFT_GAME_DIR}/scripts/entrypoint.sh
```

The game path fails clearly when its required entrypoint is missing. Base mode is useful for SteamCMD commands, debugging, and inspecting the image.

## What belongs where

| Layer | Responsibility |
| --- | --- |
| This repository | image, shared runtime, build and release automation |
| Game layer | game installation, configuration, and server process |
| Persistent mounts | saves, logs, backups, and operator overrides |
