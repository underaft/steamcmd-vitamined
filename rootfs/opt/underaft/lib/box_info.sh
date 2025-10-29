#!/usr/bin/env bash

# Load Libraries
. /opt/underaft/lib/log.sh
. /opt/underaft/lib/validations.sh

# This is how our box would look like
# ┌──────────────────────────────────────────────────────────────────┐
# │                            HEADER                                │
# ├──────────────────────────────────────────────────────────────────┤
# │ KEY                  : VALUE                                     │
# │                         CENTERED TEXT                            │
# ├──────────────────────────────────────────────────────────────────┤
# │                            FOOTER                                │
# └──────────────────────────────────────────────────────────────────┘

# Inner width between │ │
LOG_BOX_INNER_WIDTH="${LOG_BOX_INNER_WIDTH:-66}"
LOG_BOX_KEY_WIDTH=$(( LOG_BOX_INNER_WIDTH / 3 ))
DISABLE_BOX_RENDERING="${DISABLE_BOX_RENDERING:-"false"}"

clean_box_text() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  # Strip ANSI codes if any (optional safety)
  local text="${*:-}"
  local clean_text
  clean_text=$(echo -e "${text}" | sed 's/\x1b\[[0-9;]*m//g')
  clean_text="${clean_text//$'\n'/"\\n" }"
  echo "${clean_text}"
}

print_box_header() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  local width=${LOG_BOX_INNER_WIDTH}
  local border
  printf -v border '─%.0s' $(seq 1 "${width}")
  info "┌${border}┐"
}
print_box_separator() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  local width=${LOG_BOX_INNER_WIDTH}
  local border
  printf -v border '─%.0s' $(seq 1 "${width}")
  info "├${border}┤"
}

print_box_footer() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  local width=${LOG_BOX_INNER_WIDTH}
  local border
  printf -v border '─%.0s' $(seq 1 "${width}")
  info "└${border}┘"
}

print_box_text_left() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  local text="${*:-}"
  local line
  if [[ -n "${text}" ]]; then
    printf -v line "│ %-65s │" "${text}"
    info "${line}"
  fi
}


print_box_text_centered() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  local text="${*:-}"
  local width=${LOG_BOX_INNER_WIDTH}
  local clean_text
  clean_text="$(clean_box_text "${text}")"
  local text_len=${#clean_text}

  # Guard against empty
  if (( text_len == 0 )); then
    printf -v line "│ %-65s │" ""
    info "${line}"
    return
  fi

  # Centering math — pad evenly, extra space on right if odd difference
  local space_total=$(( width - text_len ))
  local pad_left=$(( space_total / 2 ))
  local pad_right=$(( space_total - pad_left ))

  # Truncate if too long
  if (( text_len > width )); then
    clean_text="${clean_text:0:width}"
    pad_left=0
    pad_right=0
  fi

  local line
  printf -v line "│%*s%s%*s│" "${pad_left}" "" "${clean_text}" "${pad_right}" ""
  info "${line}"
}

print_box_text_kv() {
  is_true "${DISABLE_BOX_RENDERING}" && return 0
  local key="${1:-}"
  shift || true
  local val="${*:-}"
  local line

  key="$(clean_box_text "${key}")"
  val="$(clean_box_text "${val}")"

  # Compute dynamic value width:
  # Inside the box we render: " " + KEY + " : " + VAL + " "
  # Static chars = 5 (space, space, colon, space, trailing space)
  local static_chars=5
  local val_w=$(( LOG_BOX_INNER_WIDTH - static_chars - LOG_BOX_KEY_WIDTH ))
  (( val_w < 0 )) && val_w=0

  # Truncate key if it exceeds its column
  if (( ${#key} > LOG_BOX_KEY_WIDTH )); then
    (( LOG_BOX_KEY_WIDTH >= 3 )) && key="${key:0:$((LOG_BOX_KEY_WIDTH-3))}..."
  fi

  # Truncate value to fit value column, append ellipsis (3 chars)
  if (( ${#val} > val_w )); then
    if (( val_w >= 3 )); then
      val="${val:0:$((val_w-3))}..."
    else
      val="${val:0:val_w}"
    fi
  fi

  printf -v line "│ %-*s : %-*s │" \
    "${LOG_BOX_KEY_WIDTH}" "${key}" \
    "${val_w}" "${val}"
  info "${line}"
}
