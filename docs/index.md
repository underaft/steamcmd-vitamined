# SteamCMD Vitamined

SteamCMD Vitamined is UnderAft's reusable base image for SteamCMD game servers. It supplies SteamCMD, a non-root runtime user, persistent directory conventions, shared Bash helpers, and a small runtime contract for game-specific layers.

It is not a complete game server. You provide the game files and the game entrypoint.

## Choose a path

- New operator: [Quickstart](quickstart.md)
- Understand startup: [How it works](overview.md) and [Runtime behavior](runtime.md)
- Configure persistence: [Configuration](configuration.md)
- Build a game layer: [Extending the image](extending.md)
- Maintainer or release work: [CI/CD and releases](ci-cd.md)
- Diagnose a failure: [Troubleshooting](troubleshooting.md)
- Need exact paths and commands: [Reference](reference.md)

## Runtime at a glance

```text
container start
      |
      v
entrypoint.sh -> welcome page (optional)
      |
      +-- GAME_SERVER_NAME empty -> exec the supplied command
      |
      +-- GAME_SERVER_NAME set   -> exec /opt/underaft/<name>/scripts/entrypoint.sh
```

The image defaults to base mode. A container started without a command exits immediately; use an explicit command or provide a game layer.
