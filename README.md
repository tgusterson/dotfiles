# My dotfiles

Configuration files for Neovim, tmux, Ghostty, and more are managed with [GNU Stow](https://www.gnu.org/software/stow/) to automate the creation and upkeep of symlinks.

### Setup

Requires: `git`, `curl`

To install on macOS or Linux, run:

```bash
git clone https://github.com/tgusterson/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script will:
1. Install packages (Homebrew on macOS, native package manager on Linux).
2. Install Zsh plugins (Powerlevel10k, autosuggestions, syntax-highlighting, autocomplete).
3. Install FiraMono Nerd Font for terminal icons.
4. Setup the Bat theme (TokyoNight).
5. Symlink dotfiles using Stow.
6. Install TPM (Tmux Plugin Manager).

**Note:** After installation, restart your terminal. In Tmux, press `Prefix + I` to install plugins.

