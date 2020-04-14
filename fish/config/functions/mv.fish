function mv -w mv
    if test (count $argv) -eq 1
        command mv $argv (read -p "echo 'New name: '" -c $argv)
    else
        command mv $argv
    end
end
