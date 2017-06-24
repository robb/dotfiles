function g -w git
    if test (count $argv) -eq 0
        git status --short
    else
        git $argv
    end
end
