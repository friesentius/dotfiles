# ─────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY


# ─────────────────────────────────────────────────────────────
# General shell behavior
# ─────────────────────────────────────────────────────────────

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt CORRECT

# ─────────────────────────────────────────────────────────────
# SSH agent setup
# ─────────────────────────────────────────────────────────────

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# ─────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────

autoload -Uz compinit
compinit

# Completion menu
zstyle ':completion:*' menu select

# Case-insensitive completion
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*'

# Better completion descriptions
zstyle ':completion:*:descriptions' format '[%d]'

# Group different completion types
zstyle ':completion:*' group-name ''

# Use colors in completion menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Complete hidden files without explicitly typing the dot
_comp_options+=(globdots)


# ─────────────────────────────────────────────────────────────
# Keybindings
# ─────────────────────────────────────────────────────────────

bindkey -e

# Ctrl+Left / Ctrl+Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete
bindkey '^[[3~' delete-char


# ─────────────────────────────────────────────────────────────
# History search
# ─────────────────────────────────────────────────────────────

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search


# ─────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────

# eza
alias ls='eza --icons=auto --group-directories-first'
alias l='eza --icons=auto --group-directories-first'
alias la='eza -a --icons=auto --group-directories-first'
alias ll='eza -lh --icons=auto --group-directories-first'
alias lla='eza -lah --icons=auto --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
alias lta='eza --tree --level=2 -a --icons=auto --group-directories-first'

alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ─────────────────────────────────────────────────────────────
# fzf
# ─────────────────────────────────────────────────────────────

if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi

if [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi


# ─────────────────────────────────────────────────────────────
# Autosuggestions
# ─────────────────────────────────────────────────────────────

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# ─────────────────────────────────────────────────────────────
# Syntax highlighting
#
# Keep this near the end of .zshrc.
# ─────────────────────────────────────────────────────────────

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ─────────────────────────────────────────────────────────────
# Prompt
# ─────────────────────────────────────────────────────────────

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
