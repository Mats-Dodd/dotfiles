HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

bindkey -e

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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
if [[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
