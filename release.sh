#!/usr/bin/env bash
set -euo pipefail

increment_version() {
  local version="${1}"
  local part="${2}"
  IFS='.' read -r major minor patch <<< "${version}"
  case "${part}" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
    *) echo "Invalid part to increment: ${part}" >&2; exit 1 ;;
  esac
  echo "${major}.${minor}.${patch}"
}

ask_increment_type() {
  echo "Select version increment type:"
  echo "1) major"
  echo "2) minor"
  echo "3) patch"
  printf "Choice [1-3]: "
  read -r choice
  case "${choice}" in
    1) increment_type="major" ;;
    2) increment_type="minor" ;;
    3) increment_type="patch" ;;
    *) echo "Invalid choice" >&2; exit 1 ;;
  esac
}

maybe_tag_version() {
  local tag="${1}"

  printf "Do you want to git tag? [y/N]: "
  read -r do_tag
  if [[ "${do_tag}" =~ ^[Yy]$ ]]; then
    git tag "${tag}"
    echo "Tagged version: ${tag}"
  fi
}

maybe_push_tag() {
  local tag="${1}"
  printf "Do you want to push the new tag '%s' to origin? [y/N]: " "${tag}"
  read -r push_choice
  if [[ "${push_choice}" =~ ^[Yy]$ ]]; then
    git push origin "${tag}"
    echo "Tag pushed."
  else
    echo "Tag not pushed."
  fi
}

push_images() {
  echo "Pushing ${RELEASE_VERSION}"
  docker compose push
}

build() {
  echo "Building ${RELEASE_VERSION}"
  docker compose --progress=plain build
}

get_current_tag() {
  git describe --tags --abbrev=0 2>/dev/null || echo "${DEFAULT_TAG}"
}

# 0 = local, 1 = pipeline
is_pipeline() {
  return 1
}

determine_version() {
  local new_tag current_tag
  current_tag="$(get_current_tag)"
  echo "Current version: ${current_tag}"

  if ! is_pipeline; then
    printf "Do you want to increment the version? [y/N]: "
    read -r inc_choice
    if [[ "${inc_choice}" =~ ^[Yy]$ ]]; then
      ask_increment_type
      new_tag=$(increment_version "${current_tag}" "${increment_type}")
      if [[ "${new_tag}" != "${current_tag}" ]]; then
        maybe_tag_version "${new_tag}"
        maybe_push_tag "${new_tag}"
        export RELEASE_VERSION="${new_tag}"
        echo "New Version: ${RELEASE_VERSION}"
      fi
    fi
  else
    export RELEASE_VERSION="${current_tag}"
  fi
}

build_and_push() {
  build
  printf "Do you want to push the image? [y/N]: "
  read -r push_image
  if [[ "${push_image}" =~ ^[Yy]$ ]]; then
    push_images
  fi
}

GIVEN_ARG="${1:-}"
shift || true

DEFAULT_TAG="0.1.0"
RELEASE_VERSION="latest"

export REGISTRY_URL="${REGISTRY_URL:-"registry.infra.underaft.dev"}"
determine_version
case "${GIVEN_ARG}" in
    build)       build ;;
    push)        push_images ;;
    *)           build_and_push;;
esac