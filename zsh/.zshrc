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

# Define BREW_PREFIX for later use
if (( $+commands[brew] )); then
  BREW_PREFIX="$(brew --prefix)"
else
  # Fallback if brew is not found/installed
  BREW_PREFIX="/usr/local"
fi

# Set Editor
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='nvim'
   alias vim='nvim'
fi

# ------------------------------------------------------------------------------
# 3. KEYMAPS (EMACS MODE)
# ------------------------------------------------------------------------------
# Defaulting to Emacs mode for simplicity, with a shortcut to edit in Neovim.
# (Uncomment below to re-enable Vi mode)
# bindkey -v
# bindkey -M vicmd ":" undefined-key
# export KEYTIMEOUT=1

autoload -U edit-command-line
zle -N edit-command-line

# ------------------------------------------------------------------------------
# 4. PLUGINS & COMPLETIONS
# ------------------------------------------------------------------------------
# Syntax Highlighting
[[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Autosuggestions
[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Autocomplete (Note: We load this BEFORE fzf so fzf can override it)
[[ -f "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]] && \
  source "$BREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# FZF (Loaded last to ensure it takes over the ** trigger and Tab keys)
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# Gita zsh completion
if (( $+commands[gita] )); then
  _gita_completions()
  {
    local cur commands repos cmd
    local COMP_CWORD COMP_WORDS
    read -cn COMP_CWORD
    read -Ac COMP_WORDS

    cur=${COMP_WORDS[COMP_CWORD]}
    cmd=${COMP_WORDS[2]}

    commands=`gita -h | sed '2q;d' | sed 's/[{}.,]/ /g'`
    repos=`gita ls`

    if [ -z "$cmd" ]; then
      reply=($(compgen -W "${commands}" ${cur}))
    else
      cmd_reply=($(compgen -W "${commands}" ${cmd}))
      case $cmd in
        add)
          reply=(cmd_reply $(compgen -d ${cur}))
          ;;
        ll)
          return
          ;;
        *)
          reply=($cmd_reply $(compgen -W "${repos}" ${cur}))
          ;;
      esac
    fi
  }
  compctl -K _gita_completions gita
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
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$BREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

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

# Ensure /usr/local/bin is in path
export PATH="$PATH:/usr/local/bin"

# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# Notes directory
export NOTES_DIR="$HOME/notes"

# Open a note by name, or inbox.md if no argument given
note() {
  nvim "$NOTES_DIR/${1:-inbox}.md"
}

# Search notes with rg+fzf, open result in nvim at matching line
sn() {
  local result file line
  result=$({
    rg --files --no-ignore-vcs "$NOTES_DIR" \
      | grep -i "${1:-.}" \
      | sed 's|.*|&:1:-- filename match --|'
    rg --color=always --line-number --smart-case --no-ignore-vcs "${1:-.}" "$NOTES_DIR"
  } | fzf --ansi --delimiter=: \
          --preview 'if [[ {1} == *.md ]]; then CLICOLOR_FORCE=1 glow -s dark -w 60 {1}; else bat --color=always --highlight-line {2} {1}; fi' \
          --preview-window 'right:60%,+{2}+3/3')
  [[ -z "$result" ]] && return
  file=$(cut -d: -f1 <<< "$result")
  line=$(cut -d: -f2 <<< "$result")
  nvim +"$line" "$file"
}

# Open lazygit in a fuzzy-selected repo
lg() {
  local repo
  repo=$(find ~/repos -name ".git" -type d -maxdepth 3 | sed 's|/.git||' | fzf -q "${1:-}" --select-1)
  [ -n "$repo" ] && lazygit -p "$repo"
}

# Bat theme
export BAT_THEME="tokyonight_night"

# ------------------------------------------------------------------------------
# 6. ALIASES
# ------------------------------------------------------------------------------
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
# alias pip=/usr/local/bin/pip3 # Removed hardcoded path
alias gl='gita ll'
alias gs='gita super'
alias dotfiles='cd ~/.dotfiles'
alias notes='cd ~/notes'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias start_my_day="~/start_my_day.sh"
alias ollama-serve='OLLAMA_FLASH_ATTENTION="1" OLLAMA_KV_CACHE_TYPE="q8_0" /opt/homebrew/opt/ollama/bin/ollama serve'

# ------------------------------------------------------------------------------
# 7. THEME (POWERLEVEL10K)
# ------------------------------------------------------------------------------
[[ -f "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && \
  source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh --cmd cd)"

# Force emacs keybindings last, after all plugins have loaded.
# This ensures nothing (zsh-autocomplete, fzf, etc.) silently switches to vi mode.
bindkey -e
bindkey '^v' edit-command-line
