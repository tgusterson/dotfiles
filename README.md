# My dotfiles

Configuration files for Neovim, tmux, Ghostty, and more are managed with [GNU Stow](https://www.gnu.org/software/stow/) to automate the creation and upkeep of symlinks.

### Setup

Requires: `git`, `curl`

To install on macOS or Linux (via Linuxbrew), run:

```bash
git clone https://github.com/tgusterson/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script will:
1. Install Homebrew (if missing).
2. Install required packages (Neovim, Tmux, Zsh plugins, etc.).
3. Setup the Bat theme (TokyoNight).
4. Symlink dotfiles using Stow.
5. Install TPM (Tmux Plugin Manager).

**Note:** After installation, restart your terminal. In Tmux, press `Prefix + I` to install plugins.

