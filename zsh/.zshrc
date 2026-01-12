# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Created by `pipx` on 2024-11-21 19:12:24
export PATH="$PATH:$HOME/.local/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.cache/lm-studio/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PYTHON=$(which python3)

# Git aliases
alias g='git'
alias gs='git status'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log'

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"


# Fast Deploy function with Claude Code commit message generation  
function ds() {
    # Stage all changes
    git add -A
    
    # Check if there are changes to commit
    if ! git diff --cached --quiet; then
        echo "Analyzing changes with Claude Code..."
        
        # Get staged changes for Claude to analyze
        local changes=$(git diff --cached --name-status)
        local diff_output=$(git diff --cached)
        
        # Use Claude Code to generate commit message
        local prompt="Write only a single line commit message for these changes (no quotes, no extra text): Changed files: $changes"
        local commit_msg=$(echo "$prompt" | claude --print --model haiku --allowed-tools "Read,Grep,Glob" 2>/dev/null | grep -v "🤖" | grep -v "Co-Authored" | grep -v "Generated" | grep -v "\`\`\`" | head -1 | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        
        # Fallback if Claude fails or returns empty
        if [[ -z "$commit_msg" ]]; then
            echo "Claude failed to generate message, using default..."
            commit_msg="Update files: $(echo "$changes" | awk '{print $2}' | tr '\n' ' ' | sed 's/ $//')"
        fi
        
        echo "Commit message: $commit_msg"
        
        # Commit and push
        git commit -m "$commit_msg"
        git push origin HEAD
        
        echo "✅ Changes committed and pushed!"
    else
        echo "No changes to commit."
    fi
}

# Ghostty shell integration
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# Initialize zoxide
eval "$(zoxide init zsh)"

# ============================================
# Shell Enhancement Tools
# ============================================

# zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# fzf customizations
# Use fd if you have it (faster than find, respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Preview files in ctrl+t
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}' 2>/dev/null"

# Better history search
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'  # Muted gray color

# zsh-syntax-highlighting (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Muted syntax highlighting colors
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,dim'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,dim'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,dim'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan,dim'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,dim'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,dim'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white,dim'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,dim'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=white,dim'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=white,dim'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,dim'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,dim'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta,dim'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=magenta,dim'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=yellow,dim'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=white,dim'
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green,dim'

eval "$(starship init zsh)"
