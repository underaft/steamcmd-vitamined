---
title: Troubleshooting
description: Symptom-to-cause-to-solution guidance for common startup, logging, and persistence issues.
---

# Troubleshooting

If something went wrong, use the tables below to map what you see to likely causes and actionable next steps.

## Startup failures

| Symptom | Cause | Solution |
|---------|-------|----------|
| Container exits immediately | Base mode with no command provided | Provide a command: `docker compose run --rm steamcmd-vitamined bash` |
| "NO GAME ENTRYPOINT FOUND" error | `GAME_SERVER_NAME` set but `entrypoint.sh` missing | Create `${UFT_GAME_DIR}/scripts/entrypoint.sh` or unset `GAME_SERVER_NAME` |
| Permission denied on files | Volume ownership mismatch | Ensure host directory owned by `USER_ID` (default: `1000`) |

## Logging issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| No log output | `LOG_LEVEL` too high | Set `LOG_LEVEL=info` or `LOG_LEVEL=debug` |
| Too much output | `LOG_LEVEL=debug` | Set `LOG_LEVEL=warn` or `LOG_LEVEL=error` |
| No welcome page | `PRINT_WELCOME_PAGE=false` | Set `PRINT_WELCOME_PAGE=true` |

## Persistence issues

| Symptom | Cause | Solution |
|---------|-------|----------|
| Data lost on container restart | Volume not mounted | Add volume mount in `docker-compose.yaml` |
| Permission denied on volume | Host UID mismatch | `chown -R 1000:1000 ./data` on host |
| Backups not created | `BACKUPS_BASE_DIR` not mounted | Mount backups volume |

## Diagnostic commands

```bash
# View container logs
docker compose logs steamcmd-vitamined

# Execute command in running container
docker compose exec steamcmd-vitamined bash

# Run with debug tracing
docker compose run --rm -e SCRIPT_DEBUG=true steamcmd-vitamined bash

# Check file permissions inside container
docker compose run --rm steamcmd-vitamined ls -la /opt/underaft

# Verify environment variables
docker compose run --rm steamcmd-vitamined env | grep -E '^(GAME_SERVER_NAME|UFT_|LOG_)'
```

## Error message index

| Error Message | Source | Meaning |
|---------------|--------|---------|
| "NO GAME ENTRYPOINT FOUND" | `entrypoint.sh:20` | `GAME_SERVER_NAME` set but `${UFT_GAME_DIR}/scripts/entrypoint.sh` doesn't exist |
| "Running base entrypoint" | `entrypoint.sh:34` | `GAME_SERVER_NAME` not set, running in base mode |

## Quick checklist

- [ ] Is `GAME_SERVER_NAME` set correctly?
- [ ] Does `entrypoint.sh` exist at the right path?
- [ ] Are volumes mounted with correct ownership?
- [ ] Is `LOG_LEVEL` set appropriately?
- [ ] Try `SCRIPT_DEBUG=true` for detailed trace

## Related pages

- [Known issues](./known-issues.md) for verified bugs
- [Runtime modes](./run/runtime-modes.md) for mode behavior
- [Filesystem and volumes](./run/filesystem-and-volumes.md) for mount guidance

---

**Navigation:** [Docs home](./index.md)
