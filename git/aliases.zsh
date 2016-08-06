g () {
  if [ $# -eq 0 ]
  then
    git status -sb
  else
    git "$@"
  fi
}
compdef g=git

alias gl='git log --oneline --decorate --graph --all'
compdef _git gl=git-log

alias gs='git status'
compdef _git gs=git-status
