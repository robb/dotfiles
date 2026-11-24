function pi --description "Run pi in a Seatbelt sandbox that can only touch the current project"
    set -l profile ~/.dotfiles/pi/pi.sb

    # Run unsandboxed when asked to, or when already inside the sandbox
    # (Seatbelt sandboxes can't be nested).
    if set -q PI_NO_SANDBOX; or set -q PI_SANDBOX
        command pi $argv
        return
    end

    if not test -f $profile
        echo "pi: sandbox profile $profile is missing; run with PI_NO_SANDBOX=1 to skip it" >&2
        return 1
    end

    # The project is the git root, so pi can edit the whole repo from a subfolder.
    # Seatbelt matches real paths, so resolve symlinks (e.g. /tmp -> /private/tmp).
    set -l project (path resolve (git rev-parse --show-toplevel 2>/dev/null; or pwd))

    if contains -- $project (path resolve $HOME) /
        echo "pi: won't sandbox with $project as the project; cd into a project or use PI_NO_SANDBOX=1" >&2
        return 1
    end

    PI_SANDBOX=1 sandbox-exec -f $profile \
        -D HOME=(path resolve $HOME) -D PROJECT=$project \
        (command -s pi) $argv
end
