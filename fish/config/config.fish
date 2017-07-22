# iTerm2 integration
source ~/.config/fish/iterm2_shell_integration.fish

# Locale
set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"

# Homebrew
set PATH "/usr/local/sbin" $PATH

function update_profile --on-variable iterm2_profile
    echo -ne "\033]1337;SetProfile="$iterm2_profile"\a"
end

function fish_greeting
    echo -ne "\033]1337;SetProfile="$iterm2_profile"\a"
end
