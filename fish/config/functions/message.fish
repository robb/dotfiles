function message --argument-names from to message --description "Sends a message via iMessage.\nUsage: message sender recipient message"
    echo "\
        tell application \"Messages\"
            send \"$message\" to buddy \"$to\" of service \"E:$from\"
        end tell" | osascript > /dev/null
end
