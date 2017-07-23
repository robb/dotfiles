if status --is-interactive
    set -g fish_user_abbreviations

    abbr --add gl 'g log --pretty=oneline --decorate --abbrev-commit'
end
