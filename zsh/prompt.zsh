# Enable colors
source ~/.dotfiles/zsh/spectrum.zsh
autoload colors && colors

# Enable substitutions
setopt prompt_subst

PROMPT='$(left_prompt)'
RPROMPT='$(right_prompt)'

function left_prompt() {
  cols="$(tput cols)"
  if [ "$cols" -gt 88 ]; then
    echo "%{$FG[214]%}%2c $(git_prompt) $(git_dirty_state) %{$reset_color%}"
  else
    echo "%{$FG[214]%}%2c %{$reset_color%}"
  fi
}

function right_prompt() {
  cols="$(tput cols)"
  if [ "$cols" -le 88 ]; then
    echo " $(git_dirty_state) $(git_prompt)"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[045]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$FG[045]%})%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX="%{$FG[063]%}"
ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DETACHED_PREFIX="%{$FG[009]%}"
ZSH_THEME_GIT_PROMPT_DETACHED_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$FG[142]%}○"
ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[142]%}●"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Name of the current branch
function git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

# Short SHA of the current head
function git_short_sha() {
  sha=$(git rev-parse --short HEAD 2> /dev/null)
  echo "$sha"
}

# Name of the current remote
function git_remote_name() {
  remote=$(git config branch.$(git_current_branch).remote 2> /dev/null) || return
  echo "$remote"
}

# Refspec marked for merging
function git_merge_name() {
  merge=$(git config branch.$(git_current_branch).merge 2> /dev/null) || return
  echo "$merge"
}

function git_remote_ref() {
  remote="$(git_remote_name 2> /dev/null)"
  if [ "$remote" = "." ]; then
    echo "$(git_merge_name)"
  else
    merge=$(git_merge_name)
    echo "refs/remotes/$(git_remote_name)/${merge#refs/heads/}"
  fi
}

function git_ahead_behind_state() {
  list="$(git rev-list --left-right $(git_remote_ref)...HEAD 2> /dev/null)"
  ahead=$(echo $list | grep '>' | wc -l | tr -d ' ')
  behind=$(echo $list | grep '<' | wc -l | tr -d ' ')

  if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
    echo "%{$FG[045]%}:%{$FG[118]%}$ahead%{$reset_color%},%{$FG[009]%}$behind"
  elif [ "$ahead" -gt 0 ]; then
    echo "%{$FG[045]%}:%{$FG[118]%}$ahead"
  elif [ "$behind" -gt 0 ]; then
    echo "%{$FG[045]%}:%{$FG[009]%}$behind"
  fi
}

function git_branch_state() {
  branch="$(git_current_branch)"
  if [ -n "$branch" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX$branch$ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX$(git_ahead_behind_state)"
  else
    sha="$(git_short_sha)"
    echo "$ZSH_THEME_GIT_PROMPT_DETACHED_PREFIX$sha$ZSH_THEME_GIT_PROMPT_DETACHED_SUFFIX"
  fi
}

function git_dirty_state() {
  sha="$(git_short_sha)"
  if [ -z "$sha" ]; then
    return
  fi

  untracked="$(git ls-files --other --exclude-standard | wc -l | tr -d ' ')"
  changed="$(git diff --name-status | wc -l | tr -d ' ')"
  staged="$(git diff --staged --name-status | wc -l | tr -d ' ')"

  if  [ "$staged" -gt 0 ]; then
    echo "$ZSH_THEME_GIT_PROMPT_STAGED"
  elif [ "$untracked" -gt 0 ] || [ "$changed" -gt 0 ]; then
    echo "$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

function git_prompt() {
  sha="$(git_short_sha)"
  if [ -n "$sha" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_branch_state)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}
