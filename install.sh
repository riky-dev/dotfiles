#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"

echo "==> Setting up dotfiles from: $DOTFILES_DIR"

link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "  [OK] Already linked: $dest -> $src"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "  [BACKUP] Existing $dest moved to ${dest}${BACKUP_SUFFIX}"
        mv "$dest" "${dest}${BACKUP_SUFFIX}"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "  [LINKED] $dest -> $src"
}

# Symlink core configs
echo ""
echo "--> Creating symlinks..."
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua"
link_file "$DOTFILES_DIR/.bash_aliases" "$HOME/.bash_aliases"
link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# GNOME settings loader option
if [ "$1" = "--gnome" ]; then
    echo ""
    echo "--> Applying GNOME dconf settings..."
    "$DOTFILES_DIR/gnome/load-settings.sh"
else
    echo ""
    echo "--> GNOME settings not applied automatically."
    echo "    To apply GNOME extensions and keybindings settings, run:"
    echo "      $DOTFILES_DIR/gnome/load-settings.sh"
    echo "    or re-run this script with: ./install.sh --gnome"
fi

echo ""
echo "==> Dotfiles setup complete!"
echo ""
echo "Recommended packages to install on a fresh Debian system:"
echo "  - tmux, wezterm, starship"
echo "  - gnome-shell-extension-manager (to install extensions listed in gnome/extensions-enabled.txt)"
