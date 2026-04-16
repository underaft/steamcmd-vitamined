#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh
. /opt/underaft/lib/fs.sh

fetch_json() {
    local url="${1}"
    curl --no-progress-meter -fsSLJ \
      --retry 3 --retry-delay 10 --retry-all-errors \
      --connect-timeout 5 --max-time 30 "${url}"
}

get_remote_filename() {
    local url="${1}"
    curl -sIL \
      --retry 3 --retry-delay 10 --retry-all-errors \
      --connect-timeout 5 --max-time 30 "${url}" | awk -F'filename=' '/filename=/ {
        gsub(/[";\r]/, "", $2);
        print $2;
        exit
    }'
}

download_to_folder() {
  local folder="${1}" url="${2}" file="${3}"
  create_directories "${folder}"
  debug "Downloading ${file} into ${folder} from ${url}"
  curl --no-progress-meter -fsSLJ -o "${folder}/${file}" \
    --retry 3 --retry-delay 10 --retry-all-errors \
    --connect-timeout 5 --max-time 30 \
    "${url}"
}

download_github_asset() {
  local folder="${1}" asset="${2}" url="${3}"

  local json download_url release_name published_at
  json=$(fetch_json "${url}")
  download_url=$(jq -r --arg asset "$asset" '.assets[] | select(.name==$asset) | .browser_download_url' <<< "${json}")
  if [[ -z "${download_url}" ]]; then
    err "Could not fetch download url for ${2}"
    return 0
  fi
  release_name=$(jq -r '.name' <<< "${json}")
  published_at=$(jq -r '.published_at' <<< "${json}")

  debug "Downloading ${asset} v${release_name} (${published_at})"
  if download_to_folder "${folder}" "${download_url}" "${asset}"; then
    return 0
  fi
  return 1
}
