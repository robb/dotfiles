function gwatch --description "Watch the current git repo and redraw `git status --short` on change."
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    or begin
        echo "gwatch: not a git repository" >&2
        return 1
    end

    set -l last __gwatch_initial__
    function __gwatch_draw --no-scope-shadowing
        # --no-optional-locks keeps `git status` from rewriting .git/index,
        # which would otherwise trigger another file system event.
        set -l out (git --no-optional-locks -c color.status=always status --short 2>&1 | string collect)
        if test "$out" != "$last"
            clear
            test -n "$out"; and printf '%s\n' $out
            set last $out
        end
    end

    # Hide the cursor. Ctrl-C aborts the function before its last lines
    # run, so the cursor comes back from a one-shot handler that fires
    # when the next prompt is drawn.
    printf '\e[?25l'

    # Inside Rex, label the pane and restore the old label afterwards.
    set -e __gwatch_rex_label
    if set -q REX_BLOCK; and command -q rex
        set -l label (rex block inspect $REX_BLOCK --json 2>/dev/null | jq -r '.block.label // empty')
        set -l dir (string replace -r '^'(string escape --style=regex $HOME) '~' $root)
        if test -n "$label"; and rex block rename $REX_BLOCK "Git status for $dir" >/dev/null 2>&1
            set -g __gwatch_rex_label $label
        end
    end

    function __gwatch_cleanup --on-event fish_prompt
        printf '\e[?25h'
        if set -q __gwatch_rex_label
            rex block rename $REX_BLOCK $__gwatch_rex_label >/dev/null 2>&1
            set -e __gwatch_rex_label
        end
        functions -e __gwatch_draw __gwatch_cleanup
    end

    __gwatch_draw

    if command -q fswatch
        # -o: one line per batch of events; --latency coalesces bursts.
        fswatch -o -r --latency 0.2 $root | while read -l batch
            __gwatch_draw
        end
    else
        echo "gwatch: fswatch not found, polling (brew install fswatch)" >&2
        while sleep 1
            __gwatch_draw
        end
    end
end
