---
title: Quickstart
description: Fastest verified path to build and inspect the base image.
---

# Quickstart

Fastest way to confirm this image works.

## Prerequisites

- Docker and Docker Compose installed
- ~2GB free disk space for the image build
- Internet connection (SteamCMD reaches Valve servers)
- `REGISTRY_URL` set to a non-empty value (example: `REGISTRY_URL=local`)

## 1) Build the image (verified)

```bash
REGISTRY_URL=local docker compose build
```

Expected output: Docker build logs showing image layers and a successful build.

Note: this uses the repository `Dockerfile`, which builds from `steamcmd/steamcmd:debian`.

## 2) Smoke test SteamCMD (verified)

```bash
REGISTRY_URL=local docker compose run --rm steamcmd-vitamined steamcmd +quit
```

This verifies SteamCMD is reachable inside the image.

Expected output: SteamCMD startup/update/check messages, then clean quit.

## 3) Base-mode passthrough examples (unverified examples)

Run an interactive shell:

```bash
REGISTRY_URL=local docker compose run --rm steamcmd-vitamined bash
```

These passthrough examples are reference workflows and were not part of the validated command set from TASK-21/TASK-22.

Run a direct command in the container:

```bash
REGISTRY_URL=local docker compose run --rm steamcmd-vitamined ls -la /opt/underaft
```

## ⚠️ WARNING

`docker compose up -d` without an explicit command is **NOT recommended**.

From the Phase 01 audit:

- The default service has no command, so the container exits immediately.
- The service does **not** inherit `wait_forever` from the `x-base` anchor.
- Always use explicit commands with `docker compose run --rm`.

## What you have now

- A working base image with SteamCMD
- Ready to use as a base for game servers
- Also usable for direct SteamCMD commands

## Next steps

- [Runtime modes](./runtime-modes.md) — understand base mode vs game mode
- [Known issues](../known-issues.md) — current limitations

---

**Navigation:** [Docs home](../index.md)
