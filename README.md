# SteamCMD Vitamined

UnderAft's reusable Docker base image for SteamCMD game servers.

It provides SteamCMD, a non-root runtime user, persistent path conventions, shared Bash helpers, and a small game-layer contract. It does not contain a complete game server.

## Quickstart

```bash
./release.sh check
```

This builds the image locally and runs the shell, Compose, SteamCMD, and runtime smoke checks. For interactive use:

```bash
IMAGE_REF=steamcmd-vitamined:latest docker compose run --rm steamcmd-vitamined bash
```

Read the [documentation index](docs/index.md) for the operator path.

## Image channels

- `latest`: integration image published from `next`.
- `X.Y.Z`: stable image published from a plain semver tag on `main`.
- Registry: `ghcr.io/uft-gsc/steamcmd-vitamined`.

## Development

Feature pull requests target `next`. Stable releases are promoted to `main`, validated locally, tagged, and published by GitHub Actions. See [CI/CD and releases](docs/ci-cd.md) and [Repository Guide](AGENTS.md).
