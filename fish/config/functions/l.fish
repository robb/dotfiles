function l --description "Open the Linear issue for the current branch."
    set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    set -l issue (string match -r '[a-zA-Z]+-\d+' -- $branch)

    if test -z "$issue"
        echo "No Linear issue in branch: $branch" >&2
        return 1
    end

    open "linear://linear/issue/$issue"
end
