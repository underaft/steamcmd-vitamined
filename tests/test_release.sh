#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

assert_version() {
  local version="$1" expected="$2" actual
  actual="$("${repo_root}/release.sh" version "${version}")"
  [[ "${actual}" == "${expected}" ]]
}

assert_version "1.2.3" "1.2.3"
if "${repo_root}/release.sh" version "v1.2.3" >/dev/null 2>&1; then
  echo "expected v-prefixed version to fail" >&2
  exit 1
fi

echo "release CLI checks passed"
