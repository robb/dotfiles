#!/bin/sh
#
# Modeled after https://github.com/holman/dotfiles/blob/master/Rakefile

symlinks=$(find . -name "*.symlink")

for file in $symlinks; do
    basename=$(basename $file .symlink)
    target="$HOME/$basename"
    backup="$HOME/$basename.backup"

    if [ -h "$target" ]; then
        echo "removed $target"
        rm $target
    fi

    if [ -e "$backup" ] || [ -h "$backup" ]; then
        echo "restored $target"
        mv $backup $target
    fi
done
