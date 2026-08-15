# Troubleshooting

| Symptom | Cause | Next step |
| --- | --- | --- |
| Compose reports an invalid image reference | Empty or malformed `IMAGE_REF` | Set `IMAGE_REF=steamcmd-vitamined:latest` or a complete valid reference |
| Container exits immediately | Base mode received no command | Run an explicit command or configure a game layer |
| `NO GAME ENTRYPOINT FOUND` | `GAME_SERVER_NAME` points to a layer without `scripts/entrypoint.sh` | Add the required executable file under `/opt/underaft/<name>/scripts/` |
| Permission denied in a mounted directory | Host directory is not writable by the runtime UID | Change ownership/permissions to match `USER_ID` |
| SteamCMD smoke fails | Steam network access or image build failed | Run `./release.sh build`, then retry `docker compose run ... steamcmd +quit` |
| `latest` is unexpected | It represents the `next` branch, not stable `main` | Pull a plain semver tag for a stable release |

For detailed startup behavior, read [Runtime behavior](runtime.md). For exact local checks, run `./release.sh check`.
