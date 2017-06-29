function fdc --description "Opens the current working directory in Finder."
    echo "\
        set current_folder to ( POSIX file \""(pwd)\"" as alias )
        try
           tell application \"Finder\" to set the (folder of the front window) to current_folder
        on error -- no open folder windows
           tell application \"Finder\" to open current_folder
        end try

        tell application \"System Events\" to set frontmost of process \"Finder\" to true" | osascript > /dev/null
end
