if status --is-interactive
    set -g fish_user_abbreviations

    abbr --add .xco 'open *.xcodeproj'
    abbr --add .xcw 'open *.xcworkspace'
    abbr --add gl   'g log --pretty=oneline --decorate --abbrev-commit'
    abbr --add show 'open -R'
end
