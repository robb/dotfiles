function l
    set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    set issue (string match -r '[a-zA-Z]+-\d+' $branch)
    open "linear://linear/issue/$issue"
end
