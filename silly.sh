#!/bin/sh

SB_PATH=$HOME/lab/sillybytes
GH_PAGE=$SB_PATH/sillybytes.github.io
PROMPT="⚙  "

function banner
{
    echo
    echo
    echo -e '\e[33m'
    echo '  ____  _ _ _               ____        _             '
    echo ' / ___|(_) | |_   _        | __ ) _   _| |_ ___  ___  '
    echo ' \___ \| | | | | | |       |  _ \| | | | __/ _ \/ __| '
    echo '  ___) | | | | |_| |       | |_) | |_| | ||  __/\__ \ '
    echo ' |____/|_|_|_|\__, |       |____/ \__, |\__\___||___/ '
    echo '              |___/               |___/               '
    echo -e '\e[0m'
    echo
    echo
}

function deploy
{
    banner
    cd $GH_PAGE
    git stash -q --keep-index
    git checkout hakyll
    stack build
    stack exec sillybytes rebuild
    git fetch --all
    git checkout -b master --track origin/master
    rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --delete-excluded _site/ .
    git add -A
    git commit -m "Build `date +'%F'`"
    git push origin master:master
    git checkout hakyll
    git branch -D master
    git stash pop -q
}


case "$1" in
    'deploy')
        deploy
        ;;
    *)
        echo "WAT?"
        ;;
esac
