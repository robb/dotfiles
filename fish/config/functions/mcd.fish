function mcd --description "Create a directory and its parents, then cd into it."
    if test (count $argv) -ne 1
        echo "usage: mcd <directory>" >&2
        return 1
    end

    mkdir -p -- $argv[1]; and cd -- $argv[1]
end
