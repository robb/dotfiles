# Completion System
autoload -U compinit
compinit -i

# Show completion menu on succesive tab press
setopt auto_menu
setopt complete_in_word
setopt always_to_end

# Enable menu selection
zstyle ':completion:*' menu select

# Enable case insensitive and backwards completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
