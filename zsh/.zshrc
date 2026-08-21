HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

bindkey -e
zle_highlight=('default:fg=#FFC799')

eval "$(mise activate zsh)"

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export OTUI_PALETTE_IDLE_TIMEOUT_MS=1
export OPENCODE_FAST_BOOT=1


alias o='opencode'
alias g='git'
alias gs='git status --short --branch'
alias gaa='git add --all'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"

if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Loaded after fzf so Atuin owns Ctrl-R.
if (( $+commands[atuin] )); then
  eval "$(atuin init zsh)"
fi

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#595959'
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# nvm auto-use: automatically switch Node version based on .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
    local nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
        if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
        elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
            nvm use
        fi
    elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
        nvm use default
    fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
