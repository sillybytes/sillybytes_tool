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

function display_error
{
    echo -e "\e[41m\e[90m[x]\e[0m \e[31m$1\e[0m"
}

function display_success
{
    echo -e "\e[42m\e[90m[✓]\e[0m \e[32m$1\e[0m"
}

function deploy
{
    # if [[ ! -d "$GH_PAGE" ]]; then

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


banner
case "$1" in
    'deploy')
        deploy
        ;;
    *)
        echo "WAT?"
        ;;
esac
