# ------------------------------------------------------------------------------
# 1. POWERLEVEL10K INSTANT PROMPT
# ------------------------------------------------------------------------------
# This must stay at the very top to ensure the prompt stays fast.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------------------------------------------
# 2. CORE ENVIRONMENT & HOMEBREW
# ------------------------------------------------------------------------------
# Initialize Homebrew dynamically
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Define BREW_PREFIX for later use (empty if brew not installed)
if (( $+commands[brew] )); then
  BREW_PREFIX="$(brew --prefix)"
else
  BREW_PREFIX=""
fi

# Set Editor
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
   alias vim='nvim'
fi

# ------------------------------------------------------------------------------
# 3. KEYMAPS (VI MODE)
# ------------------------------------------------------------------------------
# Set Vi mode BEFORE loading plugins so they bind to the correct keymap
bindkey -v
bindkey -M vicmd ":" undefined-key
export KEYTIMEOUT=1 # Reduces delay when hitting ESC

# ------------------------------------------------------------------------------
# 4. PLUGINS & COMPLETIONS
# ------------------------------------------------------------------------------
# Define potential plugin paths
ZSH_PLUGINS_LOCAL="$HOME/.local/share"

# Syntax Highlighting
if [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "$ZSH_PLUGINS_LOCAL/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_PLUGINS_LOCAL/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Autosuggestions
if [[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$ZSH_PLUGINS_LOCAL/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_PLUGINS_LOCAL/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Autocomplete
if [[ -f "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  source "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
elif [[ -f "$ZSH_PLUGINS_LOCAL/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]]; then
  source "$ZSH_PLUGINS_LOCAL/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

# FZF (Loaded last to ensure it takes over the ** trigger and Tab keys)
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# ------------------------------------------------------------------------------
# 5. LANGUAGE & TOOL INITIALIZATION
# ------------------------------------------------------------------------------

# FZF Options
export FZF_DEFAULT_OPTS="
  --height 50% 
  --layout=reverse 
  --border 
  --preview '[[ \$(file --mime-type -b {}) == text/* ]] && bat --style=numbers --color=always --line-range :500 {} || file -b {}'
  --preview-window=right:60%
"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
if [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ]; then
  source "$BREW_PREFIX/opt/nvm/nvm.sh"
elif [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
fi

# PNPM
if [[ "$(uname -s)" == "Darwin" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Go
export GOPATH=$HOME/go
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Ensure /usr/local/bin and ~/.local/bin are in path
export PATH="$HOME/.local/bin:$PATH:/usr/local/bin"

# Bat theme
export BAT_THEME="tokyonight_night"

# ------------------------------------------------------------------------------
# 6. ALIASES
# ------------------------------------------------------------------------------
if (( $+commands[brew] )); then
  alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
fi
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias start_my_day="~/start_my_day.sh"

# ------------------------------------------------------------------------------
# 7. THEME (POWERLEVEL10K)
# ------------------------------------------------------------------------------
if [[ -f "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -f "$ZSH_PLUGINS_LOCAL/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$ZSH_PLUGINS_LOCAL/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
