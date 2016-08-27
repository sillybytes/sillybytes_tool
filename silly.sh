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
    echo -e "   go     \t Go to www.sillybytes.net"
    echo -e "   new    \t Generate boilerplate for new post"
    echo -e "   deploy \t Deploy update"
}

function test_premises
{
    if [[ ! -f "post.md" ]]; then
        display_error "\"post.md\" file not found"
        exit 1
    fi
}

function generate
{
    test_premises

    rm -f post.html
    sed -n '1!p' post.md | pandoc -o post.html
}


function deploy
{
}


banner
case "$1" in
    'go')
        xdg-open "http://www.sillybytes.net"
        ;;
    'deploy')
        deploy
        ;;
    *)
        display_usage
        ;;
esac
