#!/bin/sh
#
# Modeled after https://github.com/holman/dotfiles/blob/master/Rakefile

symlinks=$(find . -name "*.symlink")

overwrite_all=false
backup_all=false

for file in $symlinks; do
    overwrite=false
    backup=false

    basename=$(basename $file .symlink)
    target="$HOME/$basename"

    if [ -e "$target" ] || [ -h "$target" ]; then
        if ! $overwrite_all && ! $backup_all; then
            while true; do
                echo "$target already exists"
                echo "[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all "
                read answer
                case $answer in
                    "s" ) continue 2;; # continue the outer for loop
                    "S" ) break 2;;    # break out of the outer for loop
                    "o" ) overwrite=true; break;;
                    "O" ) overwrite_all=true; break;;
                    "b" ) backup=true; break;;
                    "B" ) backup_all=true; break;;
                    *   ) continue ;;
                esac
            done
        fi

        if $overwrite || $overwrite_all; then
            rm $target
        fi

        if $backup  || $backup_all; then
            mv $target "$HOME/$basename.backup"
        fi
    fi

    echo "Installing $target"
    ln -s "$PWD/$file" "$target"
done

set -e

find . -name "*.install" | while read installer ; do sh -c "${installer}" ; done
