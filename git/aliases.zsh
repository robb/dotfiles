g () {
  if [ $# -eq 0 ]
  then
    git status -sb
  else
    git $*
  fi
}
compdef g=git

alias gl='git log --pretty=oneline --decorate --abbrev-commit'
compdef _git gl=git-lig

alias gs='git status'
compdef _git gs=git-status
