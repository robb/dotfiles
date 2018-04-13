#!/bin/sh
set -e

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.dotfiles/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1

echo "Linking ~/.dotfiles/iterm2/profiles to ~/Library/Application Support/iTerm2/DynamicProfiles"

mkdir -p "~/Library/Application Support/iTerm2/"
rm -rf "~/Library/Application Support/iTerm2/DynamicProfiles"

ln -sfF ~/.dotfiles/iterm2/profiles ~/Library/Application\ Support/iTerm2/DynamicProfiles
