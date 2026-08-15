#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${repo_root}"

if [[ -f .env ]]; then
  # shellcheck source=/dev/null
  source .env
fi

IMAGE_REF="${IMAGE_REF:-steamcmd-vitamined:${RELEASE_VERSION:-latest}}"

usage() {
  cat <<'EOF'
Usage:
  ./release.sh check [--skip-build]
  ./release.sh build [image-ref]
  ./release.sh release X.Y.Z
  ./release.sh version X.Y.Z

The release command validates and builds locally, then creates a local tag.
It never pushes images or Git refs.
EOF
}

validate_version() {
  local version="${1:-}"
  [[ "${version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || {
    echo "invalid version: ${version}" >&2
    return 1
  }
  printf '%s\n' "${version}"
}

shellcheck_files() {
  shellcheck -e SC1091 release.sh tests/*.sh rootfs/opt/underaft/lib/*.sh rootfs/opt/underaft/scripts/*.sh
}

compose_config() {
  IMAGE_REF="${IMAGE_REF}" docker compose config --quiet
}

build_image() {
  echo "Building ${IMAGE_REF}"
  IMAGE_REF="${IMAGE_REF}" docker compose --progress=plain build
}

steamcmd_smoke() {
  IMAGE_REF="${IMAGE_REF}" docker compose run --rm steamcmd-vitamined steamcmd +quit
}

runtime_smoke() {
  local output
  output="$(IMAGE_REF="${IMAGE_REF}" docker compose run --rm steamcmd-vitamined echo smoke)"
  [[ "${output}" == *smoke* ]]

  IMAGE_REF="${IMAGE_REF}" docker compose run --rm steamcmd-vitamined >/dev/null

  if IMAGE_REF="${IMAGE_REF}" docker compose run --rm -e GAME_SERVER_NAME=test steamcmd-vitamined >/dev/null 2>&1; then
    echo "game mode unexpectedly succeeded without an entrypoint" >&2
    return 1
  fi
}

check() {
  local skip_build=false
  if [[ "${1:-}" == "--skip-build" ]]; then
    skip_build=true
  fi

  echo "Linting shell scripts"
  shellcheck_files
  echo "Validating Compose configuration"
  compose_config
  if [[ "${skip_build}" == false ]]; then
    build_image
  fi
  echo "Running SteamCMD smoke test"
  steamcmd_smoke
  echo "Running runtime smoke tests"
  runtime_smoke
  echo "Local validation passed"
}

build() {
  if [[ -n "${1:-}" ]]; then
    IMAGE_REF="${1}"
  fi
  build_image
}

release() {
  local version image_ref
  version="$(validate_version "${1:-}")"
  image_ref="steamcmd-vitamined:${version}"
  IMAGE_REF="${image_ref}" check
  if git rev-parse "refs/tags/${version}" >/dev/null 2>&1; then
    echo "tag already exists: ${version}" >&2
    return 1
  fi
  git tag "${version}"
  echo "Created local tag ${version}; push it manually when ready."
}

case "${1:-check}" in
  check)
    shift || true
    check "${1:-}"
    ;;
  build)
    shift || true
    build "${1:-}"
    ;;
  release)
    shift || true
    release "${1:-}"
    ;;
  version)
    shift || true
    validate_version "${1:-}"
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
