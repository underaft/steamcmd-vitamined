# Extending the image for a game

This repository supplies the base runtime. A game-specific image or mounted layer supplies the game process.

## Minimum contract

```text
/opt/underaft/<game>/
├── scripts/
│   └── entrypoint.sh   required and executable
└── bin/                optional commands added to PATH
```

Run it with `GAME_SERVER_NAME=<game>`. The runtime then executes the required entrypoint as the container's main process.

## Derived image

```dockerfile
FROM ghcr.io/underaft/steamcmd-vitamined:<version>
COPY game-layer/ /opt/underaft/mygame/
ENV GAME_SERVER_NAME=mygame
```

Keep game installation and configuration in the derived image or mounted volumes. Do not modify the shared runtime just to add game-specific behavior.

## Useful helpers

| Helper | Capability |
| --- | --- |
| `log.sh` | `info`, `warn`, `err`, and `debug` output |
| `fs.sh` | directory creation, ownership, and synchronization |
| `steam.sh` | Steam app installation helper |
| `requests.sh` | JSON and download helpers |
| `validations.sh` | truthy and integer checks |
| `os.sh` | idle and stdout redirection helpers |

Source the helper you need from `/opt/underaft/lib`; avoid copying its implementation into the game layer.
