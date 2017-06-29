function cdf --description "Navigate to the folder of the frontmost Finder window."
    set path (echo "\
        tell application \"Finder\" to set the source_folder to (folder of the front window) as alias

        set result to (POSIX path of the source_folder as string)" | osascript ^ /dev/null)

    and cd $path
end
