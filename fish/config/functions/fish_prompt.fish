set fish_color_autosuggestion -i blue
set fish_color_command -i
set fish_color_error -i red
set fish_color_match -i black
set fish_color_operator -i
set fish_color_param -i
set fish_color_quote -i -o blue
set fish_color_valid_path -i F80

function fish_prompt
    if test $status -eq 0
        set exit_color normal
    else
        set exit_color red
    end

    set cwd (printf "%s%s%s" (set_color normal | set_color -o) \
                             (pwd | sed -e "s|^$HOME|~|" | rev | cut -d '/' -f '1 2' | rev) \
                             (set_color normal))

    # Test if we're inside a git directory
    if git rev-parse --git-dir > /dev/null 2>&1
        # Print a git prompt
        begin
            # Print the current branch name or sha if we're in detached HEAD.
            set current_branch (git symbolic-ref --quiet --short HEAD | tr -d '[:space:]')

            if test -n "$current_branch"
                set branch_state (printf " at %s%s%s" (set_color normal | set_color -o) \
                                                      $current_branch \
                                                      (set_color normal))
            else
                set branch_state (printf " at %s%s%s" (set_color -o red) \
                                                      (git rev-parse --short HEAD 2> /dev/null) \
                                                      (set_color normal))
            end

            # Print how many commits we're ahead or behind upstream
            set remote_ref (git for-each-ref --format='%(upstream:short)' (git symbolic-ref -q HEAD))

            if test -n "$remote_ref"
                set ahead  (git rev-list --left-right $remote_ref...HEAD 2> /dev/null | grep '>' | wc -l | tr -d ' ')
                set behind (git rev-list --left-right $remote_ref...HEAD 2> /dev/null | grep '<' | wc -l | tr -d ' ')

                if test $ahead -gt 0 -a $behind -gt 0
                    set ahead_behind_state (printf ", %s􀄨 %s%s%s, %s􀄩 %s%s%s" (set_color normal) (set_color -o) $ahead  (set_color normal) \
                                                                               (set_color normal) (set_color -o) $behind (set_color normal))
                else if test $ahead -gt 0
                    set ahead_behind_state (printf ", %s􀄨 %s%s%s" (set_color normal) (set_color -o) $ahead (set_color normal))
                else if test $behind -gt 0
                    set ahead_behind_state (printf ", %s􀄩 %s%s%s" (set_color normal) (set_color -o) $behind (set_color normal))
                end

                set git_prompt "$branch_state""$ahead_behind_state"
            else
                set git_prompt "$branch_state"
            end
        end

        # Separator
        begin
            git diff-index --quiet --cached HEAD 2> /dev/null
            set -l staged $status

            git diff-files --name-only | git diff --quiet 2> /dev/null
            set -l changed $status

            test -z (git ls-files --exclude-standard --others) 2> /dev/null
            set -l untracked $status

            if test $staged = 1
                set separator '􀈸 '
            else if test $untracked = 1 -o $changed = 1
                set separator '􀈷 '
            else
                set separator '􀆊 '
            end
        end
    else
        set git_prompt ''
        set separator '􀆊 '
    end

    printf '%s􀒆 %s%s%s %s%s ' (set_color $exit_color) \
                              (set_color normal) \
                              $cwd \
                              $git_prompt \
                              (set_color normal) \
                              $separator
end
