# Abbreviations
source ~/.config/fish/abbreviations.fish

# Locale
set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"

# Homebrew
set -x HOMEBREW_NO_ANALYTICS 1

function fish_greeting
    clear
end

function fish_title
end

# Homebrew
if test -d /usr/local/sbin
    set PATH "/usr/local/sbin" $PATH
end

# Rust
if test -d ~/.cargo/bin
    set PATH "$HOME/.cargo/bin" $PATH
end

# Initialize RVM
if type -q rvm
    rvm default
end

# npm
if test -d ~/Developer/.npm-global
    set PATH "$HOME/Developer/.npm-global/bin" $PATH
end
