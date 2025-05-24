My config files.

Requires: Homebrew

Open terminal and run the below:

# 1. Clone config.nvim into ~/
REPO_URL="https://github.com/tgusterson/dotfiles"
CLONE_DIR="$HOME/.dotfiles"

if [ -d "$CLONE_DIR/.git" ]; then
  echo "↻ Updating existing config.nvim..."
  git -C "$CLONE_DIR" pull --ff-only
else
  echo "→ Cloning config.nvim into home directory..."
  git clone "$REPO_URL" "$CLONE_DIR"
fi

# 2. Install Homebrew packages
BREW_PKGS=(
  stow
  ripgrep
  fzf
  luarocks
)

echo "→ Installing Homebrew packages: ${BREW_PKGS[*]}..."
# brew install will skip already-installed ones
brew update
brew install "${BREW_PKGS[@]}"

# 3. Stow every directory under ~/.dotfiles
DOTFILES_DIR="$HOME/.dotfiles"

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "✗ Directory $DOTFILES_DIR not found — create it and put your stow modules there."
  exit 1
fi

echo "→ Applying GNU Stow for each module in $DOTFILES_DIR..."
cd "$DOTFILES_DIR"

# Only consider directories (not files);
for module in */; do
  # strip the trailing slash
  module="${module%/}"
  printf "\n» stow %-15s" "$module"
  stow "$module"
done

echo -e "\n\n✅ All done!"
