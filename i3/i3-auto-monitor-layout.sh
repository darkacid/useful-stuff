#!/usr/bin/env bash
#
# i3-auto-monitor-layout.sh
#
# Handles exactly two setups:
#   1. Laptop only
#   2. External + Laptop (External is main, positioned ABOVE internal)
#
# It saves/restores i3 workspace -> output mapping for each setup
# and runs hooks (polybar & nitrogen) on monitor state change.
#
# Dependencies: i3-msg, jq, xrandr, (optional: nitrogen, polybar_refresh.sh)
#

set -euo pipefail

### CONFIGURATION #########################################################

# Change these to match your system (see `xrandr` output)
INTERNAL_OUTPUT="eDP"
EXTERNAL_OUTPUT="HDMI-A-0"

POLL_INTERVAL=2 # seconds between checks

# Where to store per-mode layout info
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/i3-auto-layout"
mkdir -p "$STATE_DIR"

# Hooks to run on monitor state change
# Adjust these if needed. If the command/script is not in PATH,
# put the full path, e.g. "$HOME/.config/polybar/polybar_refresh.sh".
POLYBAR_REFRESH_CMD="dis bash polybar_launch.sh"
NITROGEN_RESTORE_CMD="nitrogen --restore"

##########################################################################

log() {
  printf '[i3-auto-layout] %s\n' "$*" >&2
}

# Return "dual" if external is connected, else "laptop"
current_mode() {
  if xrandr --query | awk -v out="$EXTERNAL_OUTPUT" '$1==out && $2=="connected"' | grep -q .; then
    echo "dual"
  else
    echo "laptop"
  fi
}

state_file_for_mode() {
  local mode="$1"
  echo "$STATE_DIR/layout-${mode}.json"
}

save_state_for_mode() {
  local mode="$1"
  local file
  file="$(state_file_for_mode "$mode")"

  if ! i3-msg -t get_workspaces >/dev/null 2>&1; then
    log "Could not talk to i3, skipping save for mode=$mode."
    return
  fi

  i3-msg -t get_workspaces |
    jq '{workspaces: [ .[] | {name, num, output, visible, focused} ]}' \
      >"${file}.tmp" && mv "${file}.tmp" "$file"
}

# xrandr config for dual: external is primary, laptop BELOW it
setup_dual_layout() {
  if xrandr --query | awk -v out="$EXTERNAL_OUTPUT" '$1==out && $2=="connected"' | grep -q .; then
    if ! xrandr \
      --output "$EXTERNAL_OUTPUT" --primary --auto \
      --output "$INTERNAL_OUTPUT" --auto --below "$EXTERNAL_OUTPUT"; then
      log "xrandr dual layout failed (ignoring)."
    else
      log "Configured dual layout: $EXTERNAL_OUTPUT (primary, top) + $INTERNAL_OUTPUT (bottom)."
    fi
  else
    log "Tried to set dual layout but $EXTERNAL_OUTPUT not connected."
  fi
}

# xrandr config for laptop only: external off, laptop primary
setup_laptop_layout() {
  if ! xrandr \
    --output "$EXTERNAL_OUTPUT" --off \
    --output "$INTERNAL_OUTPUT" --primary --auto; then
    log "xrandr laptop-only layout failed (ignoring)."
  else
    log "Configured laptop-only layout on $INTERNAL_OUTPUT."
  fi
}

restore_state_for_mode() {
  local mode="$1"
  local file
  file="$(state_file_for_mode "$mode")"

  if [[ ! -f "$file" ]]; then
    log "No saved layout for mode=$mode yet (first time?)."
    return 0
  fi

  log "Restoring workspace mapping for mode=$mode from $file"

  jq -c '.workspaces[]' "$file" | while read -r ws; do
    local name saved_output target_output
    name=$(jq -r '.name' <<<"$ws")
    saved_output=$(jq -r '.output' <<<"$ws")

    case "$mode" in
    dual)
      # In dual mode, keep workspaces on the same screen when possible.
      if [[ "$saved_output" == "$EXTERNAL_OUTPUT" ]]; then
        if xrandr --query | awk -v out="$EXTERNAL_OUTPUT" '$1==out && $2=="connected"' | grep -q .; then
          target_output="$EXTERNAL_OUTPUT"
        else
          target_output="$INTERNAL_OUTPUT"
        fi
      else
        target_output="$INTERNAL_OUTPUT"
      fi
      ;;
    laptop)
      # In laptop-only mode, everything on internal
      target_output="$INTERNAL_OUTPUT"
      ;;
    *)
      target_output="$saved_output"
      ;;
    esac

    i3-msg "workspace \"$name\"; move workspace to output \"$target_output\"" >/dev/null
  done
}

run_state_change_hooks() {
  log "Running state change hooks (polybar & nitrogen)."

  # polybar refresh
  if [[ -n "$POLYBAR_REFRESH_CMD" ]]; then
    if command -v ${POLYBAR_REFRESH_CMD%% *} >/dev/null 2>&1; then
      # shellcheck disable=SC2086
      $POLYBAR_REFRESH_CMD || log "polybar refresh command failed: $POLYBAR_REFRESH_CMD"
    else
      # If it's not in PATH, still try to exec it as a path string
      # shellcheck disable=SC2086
      $POLYBAR_REFRESH_CMD || log "polybar refresh command failed or not found: $POLYBAR_REFRESH_CMD"
    fi
  fi

  # nitrogen restore
  if [[ -n "$NITROGEN_RESTORE_CMD" ]]; then
    if command -v ${NITROGEN_RESTORE_CMD%% *} >/dev/null 2>&1; then
      # Run in background so it doesn't block
      # shellcheck disable=SC2086
      $NITROGEN_RESTORE_CMD >/dev/null 2>&1 || log "nitrogen restore failed: $NITROGEN_RESTORE_CMD"
    else
      # shellcheck disable=SC2086
      $NITROGEN_RESTORE_CMD >/dev/null 2>&1 || log "nitrogen restore command failed or not found: $NITROGEN_RESTORE_CMD"
    fi
  fi
}

main_loop() {
  local last_mode mode

  mode="$(current_mode)"
  last_mode="$mode"

  log "Starting in mode: $mode"

  if [[ "$mode" == "dual" ]]; then
    setup_dual_layout
  else
    setup_laptop_layout
  fi

  save_state_for_mode "$mode"

  while :; do
    sleep "$POLL_INTERVAL"

    mode="$(current_mode)"

    if [[ "$mode" != "$last_mode" ]]; then
      log "Mode change detected: $last_mode -> $mode"

      if [[ "$mode" == "dual" ]]; then
        setup_dual_layout
      else
        setup_laptop_layout
      fi

      restore_state_for_mode "$mode"

      # <<< HERE: run your hooks on monitor state change >>>
      sleep 5
      run_state_change_hooks

      last_mode="$mode"
    fi

    # Continuously update saved layout for current mode
    save_state_for_mode "$mode"
  done
}

main_loop
