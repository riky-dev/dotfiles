# Enable zsh's built-in command completions.
autoload -Uz compinit
compinit

# Initialize Starship for zsh.
eval "$(starship init zsh)"

export PATH="/Users/riccardo/.proto/shims:/Users/riccardo/.proto/bin:/Users/riccardo/go/bin:$PATH"
