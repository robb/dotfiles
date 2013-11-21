# Enable globbing for hidden files, advanced globbing
setopt globdots
setopt extendedglob

# Changing Directories
setopt auto_cd
setopt auto_pushd
setopt cdable_vars

# Completion
setopt always_to_end
setopt auto_menu
setopt complete_in_word

# Expansion and Globbing
setopt extended_glob
setopt glob_dots

# History
setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

# Input/Output
setopt correct

# Prompting
setopt prompt_subst

# Scripts and Functions
setopt multios

# zmv
autoload -U zmv
alias mmv="noglob zmv"
