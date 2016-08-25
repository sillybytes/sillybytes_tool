#!/bin/sh

SB_PATH=$HOME/lab/sillybytes
GH_PAGE=$SB_PATH/sillybytes.github.io
PROMPT="⚙  "

function banner
{
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
}

function display_error
{
    echo -e "\e[41m\e[37m[x]\e[0m \e[31m$1\e[0m"
}

function display_success
{
    echo -e "\e[42m\e[37m[✓]\e[0m \e[32m$1\e[0m"
}

function display_warning
{
    echo -e "\e[43m\e[37m[⚠]\e[0m \e[33m$1\e[0m"
}

function display_usage
{
    echo "Available commands:"
    echo -e "   new    \t Generate boilerplate for new post"
    echo -e "   deploy \t Deploy update"
}

function deploy
{
    if [[ ! -d "$GH_PAGE" ]]; then
        display_error "Repo not found at $GH_PAGE"
        exit 1
    fi

    cd $GH_PAGE

    if [[ "$(git symbolic-ref -q HEAD | cut -d '/' -f3)" != "hakyll" ]]; then
        display_error "Not in 'Hakyll' branch"
        exit 1
    fi

    git stash -q --keep-index
    stack build
    stack exec sillybytes rebuild
    git fetch --all
    git checkout -b master --track origin/master
    rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --delete-excluded _site/ .
    git add -A
    git commit -m "Build `date +'%F'`"
    git push origin master:master

    if [[ $? -ne 0 ]]; then
        display_warning "Pushing to master branch may have failed"
    fi

    git checkout hakyll
    git branch -D master
    git stash pop -q

    echo
    display_success "Deployed"
}


banner
case "$1" in
    'deploy')
        deploy
        ;;
    *)
        display_usage
        ;;
esac
