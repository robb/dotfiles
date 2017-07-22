if status --is-interactive
    set -g fish_user_abbreviations
    abbr --add gl 'git log --pretty=oneline --decorate --abbrev-commit'
end
