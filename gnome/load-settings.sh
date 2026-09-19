#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Loading GNOME settings from $SCRIPT_DIR..."

if command -v dconf >/dev/null 2>&1; then
    dconf load /org/gnome/shell/extensions/ < "$SCRIPT_DIR/extensions-settings.dconf"
    dconf load /org/gnome/desktop/wm/keybindings/ < "$SCRIPT_DIR/keybindings-wm.dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$SCRIPT_DIR/keybindings-media.dconf"
    dconf load /org/gnome/desktop/interface/ < "$SCRIPT_DIR/desktop-interface.dconf"
    echo "GNOME dconf settings successfully loaded!"
else
    echo "Error: dconf command not found. Please install dconf-cli (sudo apt install dconf-cli)." >&2
    exit 1
fi
