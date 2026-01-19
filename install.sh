#!/usr/bin/env bash
set -e

DOTFILES_DIR="${HOME}/.dotfiles"
REPO_URL="https://github.com/tgusterson/dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}ℹ $1${NC}"; }
log_success() { echo -e "${GREEN}✔ $1${NC}"; }
log_error() { echo -e "${RED}✖ $1${NC}"; }

# 1. Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

log_info "Detected OS: $MACHINE"

# 2. Setup Dotfiles Directory
if [ -d "$DOTFILES_DIR/.git" ]; then
    log_info "Updating existing dotfiles..."
    git -C "$DOTFILES_DIR" pull --ff-only
else
    log_info "Cloning dotfiles into $DOTFILES_DIR..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

# 3. Check/Install Homebrew
if ! command -v brew &> /dev/null; then
    log_info "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Brew to PATH for the current session
    if [[ "$MACHINE" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [[ "$MACHINE" == "Mac" ]]; then
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
else
    log_info "Homebrew is already installed."
fi

# 4. Install Packages
BREW_PKGS=(
  bash
  bat
  lua
  luajit
  neovim
  tmux
  tree-sitter
  powerlevel10k
  zsh-autocomplete
  zsh-syntax-highlighting
  zsh-autosuggestions
  stow
  ripgrep
  fzf
  luarocks
  lazygit
)

log_info "Installing packages..."
brew update
brew install "${BREW_PKGS[@]}"
brew autoremove
brew cleanup

# 5. Setup Bat Theme
log_info "Setting up Bat theme..."
BAT_CONFIG_DIR="$(bat --config-dir)"
mkdir -p "$BAT_CONFIG_DIR/themes"
curl -s -o "$BAT_CONFIG_DIR/themes/tokyonight_night.tmTheme" https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build

# 6. Run Stow
log_info "Applying dotfiles with Stow..."
if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "$DOTFILES_DIR not found!"
    exit 1
fi

cd "$DOTFILES_DIR"
for module in */; do
    module="${module%/}"
    # Skip .git, .claude, etc. if they are directories
    if [[ "$module" == ".git" || "$module" == ".claude" ]]; then
        continue
    fi
    
    # Only stow if it looks like a package (contains config files)
    # Actually, the user's structure has `nvim`, `tmux`, `zsh`, `ghostty` as folders
    # The loop `for module in */` matches these.
    
    echo "Stowing $module..."
    stow -v --restow --target="$HOME" "$module" 2>/dev/null || stow -v --target="$HOME" "$module"
done

# 7. Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    log_info "TPM already installed."
fi

# 8. Final Check
log_success "Installation Complete!"
echo "--------------------------------------------------------"
echo "If you are on Linux, you might need to add Homebrew to your PATH manually in your profile if not already there:"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
echo "--------------------------------------------------------"
echo "Restart your terminal or run 'source ~/.zshrc' to apply changes."
