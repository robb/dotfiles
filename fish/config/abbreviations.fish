if status --is-interactive
    abbr --add .xco 'open *.xcodeproj'
    abbr --add .xcw 'open *.xcworkspace'
    abbr --add gl   'g log --pretty=oneline --decorate --abbrev-commit --format="%C(yellow)%h%C(reset)%w("(math (tput cols) - 8)",1,8)%s"'
    abbr --add show 'open -R'
end
