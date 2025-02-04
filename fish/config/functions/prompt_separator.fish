function prompt_separator
    begin
        if not git diff-index --quiet --cached HEAD 2> /dev/null
            echo '􀈸'
            exit 0
        end

        if not git diff --quiet 2> /dev/null
            echo '􀈷'
            exit 0
        end

        if git ls-files --exclude-standard --others | read -l
            echo '􀈷'
        else
            echo '􀆊'
        end
    end
end
