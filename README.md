# dotfiles

Personal configuration files for Debian / GNOME.

## Quick Setup on a New Machine

1. Clone the repository:
   ```bash
   git clone git@github.com:riky-dev/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the install script:
   ```bash
   ./install.sh
   ```

3. (Optional) Load GNOME desktop and extension preferences:
   ```bash
   ./install.sh --gnome
   # or
   ./gnome/load-settings.sh
   ```

## macOS Apps

The apps used on macOS are listed in [`macos/Brewfile`](macos/Brewfile). On a new Mac with [Homebrew](https://brew.sh/) installed, run:

```bash
brew bundle --file=~/dotfiles/macos/Brewfile
```

To restore the saved settings for Stats, Scroll Reverser, Stretchly, and Rectangle, quit those apps and run:

```bash
./macos/restore-settings.sh
```

To refresh the saved settings from this Mac after changing them, run:

```bash
python3 ./macos/backup-settings.py
```

The backup script leaves out Stats' machine ID, Stretchly's coordinates and display identifiers, and macOS privacy permission records. Grant Rectangle Accessibility permission, and grant Scroll Reverser Accessibility and Input Monitoring permissions, on each Mac. Stretchly uses its maintainer's Homebrew tap because the default cask is disabled; macOS may warn that it is from an unidentified developer.

To update the app list later, edit `macos/Brewfile` and add or remove `cask` entries.

## Structure
- `.gitconfig` - Git configuration
- `.bash_aliases` - Custom shell aliases & Starship initialization
- `.tmux.conf` - Tmux configuration
- `.wezterm.lua` - WezTerm terminal emulator configuration
- `starship.toml` - Starship prompt configuration
- `gnome/` - Exported GNOME extensions list and dconf settings
- `macos/Brewfile` - Homebrew list of macOS apps
