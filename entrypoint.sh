#!/bin/sh

set -e

readonly keyboard="$1"
readonly keymap="$2"
readonly controller="$3"
readonly qmk_output="$4"
readonly local_keyboard="$5"
readonly local_keymap="$6"

# Used if this keyboard config does not exist in upstream QMK Firmware
if [ -n "$local_keyboard" ]; then
  keyboard_lookup_dir="/opt/vial-qmk/keyboards"

  if [ -d "$keyboard_lookup_dir/$keyboard" ]; then
    echo "Keyboard $keyboard exists in QMK Firmware, use local-keymap-path instead."
    exit 1
  fi

  echo "Copying local keyboard $local_keyboard into $keyboard_lookup_dir"
  cp -rv "$local_keyboard" "$keyboard_lookup_dir/$(basename "$local_keyboard")"
fi

# Find the keymaps directory the same way QMK CLI does
if [ -n "$local_keymap" ]; then
  keymap_lookup_dir="/opt/vial-qmk/keyboards/$keyboard"

  until find "$keymap_lookup_dir" -type d -name keymaps | grep -q .; do
    keymap_lookup_dir=$(dirname "$keymap_lookup_dir")
  done

  if [ "$keymap_lookup_dir" = "/opt/vial-qmk/keyboards" ]; then
    echo "Could not find keymaps directory for $keyboard"
    exit 1
  fi

  echo "Copying local keymap into $keymap_lookup_dir/keymaps"
  cp -rv "$local_keymap" "$keymap_lookup_dir/keymaps/$(basename "$local_keymap")"
fi

qmk config user.qmk_home=/opt/vial-qmk
cd /opt/vial-qmk
echo "make $keyboard:$keymap ${controller:+-e CONVERT_TO=$controller}"
make "$keyboard:$keymap" ${controller:+-e CONVERT_TO="$controller"}
cd $GITHUB_WORKSPACE

mkdir -vp "$qmk_output"
find "/opt/vial-qmk/.build" \( -name '*.hex' -or -name '*.bin' -or -name '*.uf2' \) -exec cp -vf {} "$qmk_output" \;

echo "built-images=$(find "$qmk_output" -type f | sed "s|^$qmk_output||" | paste -sd ',')" \
  >> "$GITHUB_OUTPUT"