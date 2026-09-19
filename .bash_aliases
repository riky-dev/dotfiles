# ~/.bash_aliases

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Starship prompt initialization
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
