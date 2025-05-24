# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh options
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Load fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias pip=/usr/local/bin/pip3

# handy fzf aliases
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# for work
alias start_my_day="~/start_my_day.sh"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion


# pnpm
export PNPM_HOME="/Users/tgusterson/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# yarn
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/binsource 

# Android SDK
# if [ -d "$HOME/Library/Android/sdk" ]; then
#   export ANDROID_HOME="$HOME/Library/Android/sdk"
# else
#   export ANDROID_HOME="$HOME/Android/Sdk"
# fi
# export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Java
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
# sudo ln -sfn /opt/homebrew/Cellar/openjdk/23.0.2/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
# export JAVA_HOME=$(/usr/libexec/java_home)
# export PATH="$JAVA_HOME/bin:$PATH"

# extend path
export PATH="$PATH:/usr/local/bin"

# Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
