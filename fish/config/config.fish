# Abbreviations
source ~/.config/fish/abbreviations.fish

# Locale
set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"

# Starship
starship init fish | source

function fish_greeting
    clear
end

function fish_title
end

# Homebrew
set -x HOMEBREW_NO_ANALYTICS 1

if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

# PATH, highest precedence first. Directories that do not exist are skipped.
set -x BUN_INSTALL "$HOME/.bun"

fish_add_path --global --move --path \
    "$HOME/.local/bin" \
    "$BUN_INSTALL/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/Developer/.npm-global/bin" \
    "/Applications/Sublime Text.app/Contents/SharedSupport/bin" \
    /usr/local/sbin
