# Pressing up/down will search the history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Make the delete key (or Fn + Delete on the Mac) work instead of outputting a ~
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

