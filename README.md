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

## Structure
- `.gitconfig` - Git configuration
- `.bash_aliases` - Custom shell aliases & Starship initialization
- `.tmux.conf` - Tmux configuration
- `.wezterm.lua` - WezTerm terminal emulator configuration
- `starship.toml` - Starship prompt configuration
- `gnome/` - Exported GNOME extensions list and dconf settings
