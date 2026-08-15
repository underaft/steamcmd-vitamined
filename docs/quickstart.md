# Quickstart

## Requirements

- Docker Engine with Compose v2
- ShellCheck for the full local gate
- Network access to the SteamCMD servers during build and smoke testing

## Validate locally

The one command used by maintainers before a release is:

```bash
./release.sh check
```

It lints the Bash files, validates Compose, builds the image, runs `steamcmd +quit`, checks command passthrough, confirms empty base-mode startup exits, and confirms game mode rejects a missing game entrypoint.

## Inspect the base image

```bash
./release.sh build steamcmd-vitamined:dev
IMAGE_REF=steamcmd-vitamined:dev docker compose run --rm steamcmd-vitamined bash
IMAGE_REF=steamcmd-vitamined:dev docker compose run --rm steamcmd-vitamined steamcmd +quit
```

Do not use `docker compose up -d` as the default smoke test. The base image has no default command and therefore exits when no command is supplied.

## Run a game layer

Set `GAME_SERVER_NAME` and mount or copy a matching layer under `/opt/underaft/<name>`:

```bash
IMAGE_REF=steamcmd-vitamined:dev \
  docker compose run --rm \
  -e GAME_SERVER_NAME=mygame \
  steamcmd-vitamined
```

The layer must contain `scripts/entrypoint.sh`; see [Extending the image](extending.md).
