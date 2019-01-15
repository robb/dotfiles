# Abbreviations
source ~/.config/fish/abbreviations.fish

# Locale
set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"

function fish_greeting
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
