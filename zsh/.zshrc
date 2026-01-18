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
# Initialize Homebrew immediately so $(brew --prefix) works in Ghostty
# eval "$(/opt/homebrew/bin/brew shellenv)"

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
# Syntax Highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Autocomplete (Note: We load this BEFORE fzf so fzf can override it)
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# FZF (Loaded last to ensure it takes over the ** trigger and Tab keys)
source <(fzf --zsh)

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
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Go
export GOPATH=$HOME/go
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Ensure /usr/local/bin is in path
export PATH="$PATH:/usr/local/bin"

# Bat theme
export BAT_THEME="tokyonight_night"

# ------------------------------------------------------------------------------
# 6. ALIASES
# ------------------------------------------------------------------------------
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias pip=/usr/local/bin/pip3
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias start_my_day="~/start_my_day.sh"

# ------------------------------------------------------------------------------
# 7. THEME (POWERLEVEL10K)
# ------------------------------------------------------------------------------
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
