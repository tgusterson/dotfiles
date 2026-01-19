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

# 3. Install Packages & Plugins based on OS
if [[ "$MACHINE" == "Mac" ]]; then
    # --- macOS (Homebrew) ---
    if ! command -v brew &> /dev/null; then
        log_info "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Initialize Homebrew (Apple Silicon or Intel)
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        log_info "Homebrew is already installed."
    fi

    BREW_PKGS=(
      bash bat lua luajit neovim tmux tree-sitter powerlevel10k
      zsh-autocomplete zsh-syntax-highlighting zsh-autosuggestions
      stow ripgrep fzf luarocks lazygit
    )

    log_info "Installing Homebrew packages..."
    brew update
    brew install "${BREW_PKGS[@]}"
    brew cleanup

    # Install Nerd Fonts for Powerlevel10k
    log_info "Installing Nerd Fonts..."
    brew install --cask font-fira-mono-nerd-font

elif [[ "$MACHINE" == "Linux" ]]; then
    # --- Linux (Native Package Manager) ---
    log_info "Installing packages via native package manager..."
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y zsh git curl stow neovim tmux ripgrep fzf bat lua5.3 luajit luarocks
        # Note: bat is often 'batcat' on Debian/Ubuntu
        mkdir -p ~/.local/bin
        ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true

    elif command -v dnf &> /dev/null; then
        sudo dnf install -y zsh git curl stow neovim tmux ripgrep fzf bat lua luajit luarocks
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm zsh git curl stow neovim tmux ripgrep fzf bat lua luajit luarocks lazygit
    else
        log_error "Unsupported Linux package manager. Please install dependencies manually."
    fi

    # Install lazygit (not in apt/dnf repos)
    if ! command -v lazygit &> /dev/null; then
        log_info "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        ARCH=$(uname -m)
        case "$ARCH" in
            x86_64)  LAZYGIT_ARCH="x86_64" ;;
            aarch64) LAZYGIT_ARCH="arm64" ;;
            armv7l)  LAZYGIT_ARCH="armv6" ;;
            *)       log_error "Unsupported architecture: $ARCH"; LAZYGIT_ARCH="" ;;
        esac
        if [[ -n "$LAZYGIT_ARCH" ]]; then
            curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
            tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
            sudo install /tmp/lazygit /usr/local/bin
            rm /tmp/lazygit.tar.gz /tmp/lazygit
        fi
    fi

    # Install tree-sitter CLI
    if ! command -v tree-sitter &> /dev/null; then
        log_info "Installing tree-sitter CLI..."
        if command -v cargo &> /dev/null; then
            cargo install tree-sitter-cli
        elif command -v npm &> /dev/null; then
            npm install -g tree-sitter-cli
        else
            log_info "Skipping tree-sitter CLI (requires cargo or npm)"
        fi
    fi

    # Manually install Zsh plugins & Powerlevel10k
    ZSH_PLUGINS_DIR="$HOME/.local/share"
    mkdir -p "$ZSH_PLUGINS_DIR"

    install_plugin() {
        local repo="$1"
        local name="$2"
        local target="$ZSH_PLUGINS_DIR/$name"
        if [ ! -d "$target" ]; then
            log_info "Cloning $name..."
            git clone --depth=1 "https://github.com/$repo" "$target"
        else
            log_info "Updating $name..."
            git -C "$target" pull
        fi
    }

    install_plugin "romkatv/powerlevel10k" "powerlevel10k"
    install_plugin "zsh-users/zsh-autosuggestions" "zsh-autosuggestions"
    install_plugin "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting"
    install_plugin "marlonrichert/zsh-autocomplete" "zsh-autocomplete"

    # Install Nerd Fonts for Powerlevel10k
    log_info "Installing Nerd Fonts..."
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraMono.tar.xz"
    curl -Lo /tmp/FiraMono.tar.xz "$FONT_URL"
    tar xf /tmp/FiraMono.tar.xz -C "$FONT_DIR"
    rm /tmp/FiraMono.tar.xz
    fc-cache -fv
fi

# 4. Setup Bat Theme
log_info "Setting up Bat theme..."
BAT_CONFIG_DIR="$(bat --config-dir 2>/dev/null || echo "$HOME/.config/bat")"
mkdir -p "$BAT_CONFIG_DIR/themes"
curl -s -o "$BAT_CONFIG_DIR/themes/tokyonight_night.tmTheme" https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
if command -v bat &> /dev/null; then
    bat cache --build
elif command -v batcat &> /dev/null; then
    batcat cache --build
fi

# 5. Run Stow
log_info "Applying dotfiles with Stow..."
if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "$DOTFILES_DIR not found!"
    exit 1
fi

cd "$DOTFILES_DIR"
for module in */; do
    module="${module%/}"
    log_info "Stowing $module..."
    stow -v --restow --target="$HOME" "$module" 2>/dev/null || stow -v --target="$HOME" "$module"
done

# 6. Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    log_info "TPM already installed."
fi

# 7. Final Check
log_success "Installation Complete!"
echo "--------------------------------------------------------"
echo "Restart your terminal or run 'source ~/.zshrc' to apply changes."

