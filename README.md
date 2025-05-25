My dotfiles
===========

Configuration files for Neovim, tmux, Ghostty, and more are managed with [GNU Stow](https://www.gnu.org/software/stow/) to automate the creation and upkeep of symlinks.

### Setup
Requires: Homebrew

Open your terminal and run the below:

```bash
# 1. Clone dotfiles into ~/.dotfiles
REPO_URL="https://github.com/tgusterson/dotfiles"
CLONE_DIR="$HOME/.dotfiles"

if [ -d "$CLONE_DIR/.git" ]; then
  echo "↻ Updating existing dotfiles..."
  git -C "$CLONE_DIR" pull --ff-only
else
  echo "→ Cloning dotfiles into your home directory..."
  git clone "$REPO_URL" "$CLONE_DIR"
fi

# 2. Install Homebrew packages
BREW_PKGS=(
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
)

echo "→ Installing Homebrew packages: ${BREW_PKGS[*]}..."
brew update
brew upgrade
brew install "${BREW_PKGS[@]}"
brew autoremove
brew cleanup

# 3. Stow every directory under ~/.dotfiles
DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "✗ Directory $DOTFILES_DIR not found — create it and put your stow modules there."
  exit 1
fi

echo "→ Applying GNU Stow for each module in $DOTFILES_DIR..."
cd "$DOTFILES_DIR"

for module in */; do
  module="${module%/}"
  printf "\n» stow %-15s" "$module"
  stow "$module"
done

# 4. Clone TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo -e "\n\n✅ All done! Run 'Ctrl + Shift + I' in tmux to install plugins.\n""
```
