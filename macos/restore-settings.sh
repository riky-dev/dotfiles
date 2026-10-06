#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS_DIR="$DOTFILES_DIR/settings"

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "This script restores macOS app settings and must run on a Mac." >&2
    exit 1
fi

if [[ ! -d "$SETTINGS_DIR" ]]; then
    echo "Settings directory not found: $SETTINGS_DIR" >&2
    exit 1
fi

for file in stats.plist scroll-reverser.plist rectangle.plist stretchly.json; do
    if [[ ! -f "$SETTINGS_DIR/$file" ]]; then
        echo "Settings file not found: $SETTINGS_DIR/$file" >&2
        exit 1
    fi
done

defaults import eu.exelban.Stats "$SETTINGS_DIR/stats.plist"
defaults import com.pilotmoon.scroll-reverser "$SETTINGS_DIR/scroll-reverser.plist"
defaults import com.knollsoft.Rectangle "$SETTINGS_DIR/rectangle.plist"

STRETCHLY_CONFIG="$HOME/Library/Application Support/Stretchly/config.json"
mkdir -p "$(dirname "$STRETCHLY_CONFIG")"
cp "$SETTINGS_DIR/stretchly.json" "$STRETCHLY_CONFIG"

echo "Settings restored. Reopen Stats, Scroll Reverser, Rectangle, and Stretchly."
