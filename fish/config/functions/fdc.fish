function fdc --description "Opens the current working directory in Finder."
    echo "\
        set myPath to ( POSIX file \""(pwd)\"" as alias )
        try
           tell application \"Finder\" to set the (folder of the front window) to myPath
           tell application \"System Events\" to set frontmost of process \"Finder\" to true
        on error -- no open folder windows
           tell application \"Finder\" to open myPath
        end try" | osascript > /dev/null
end