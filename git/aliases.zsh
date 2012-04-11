alias gl='git log --pretty=oneline --decorate'
alias gs='git status'

g () {
  if [ $# -eq 0 ]
  then
    git status -sb
  else
    git $*
  fi
}
compdef g=git
