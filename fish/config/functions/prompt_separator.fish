function prompt_separator
    begin
        git diff-index --quiet --cached HEAD 2> /dev/null
        set -l staged $status

        if test $staged = 1
            echo '􀈸'
            exit 0
        end

        git diff-files --name-only | git diff --quiet 2> /dev/null
        set -l changed $status

        if test $changed = 1
            echo '􀈷'
            exit 0
        end

        test -z (git ls-files --exclude-standard --others) 2> /dev/null
        set -l untracked $status

        if test $untracked = 1
            echo '􀈷'
        else
            echo '􀆊'
        end
    end
end
