if [[ -x $(which less) ]]
then
    export PAGER="less"
    export LESS="--ignore-case --quiet --chop-long-lines --quit-if-one-screen --no-init --raw-control-chars"
fi
