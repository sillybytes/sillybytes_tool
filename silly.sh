#!/bin/sh

SB_PATH=$HOME/lab/sillybytes
GH_PAGE=$SB_PATH/alx741.github.io
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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

function display_info
{
    echo -e "\e[46m\e[37m[•]\e[0m \e[36m$1\e[0m"
}

function display_success
{
    echo -e "\e[42m\e[37m[✓]\e[0m \e[32m$1\e[0m"
}

function display_warning
{
    echo -e "\e[43m\e[37m[⚠]\e[0m \e[33m$1\e[0m"
}

function display_error
{
    echo -e "\e[41m\e[37m[x]\e[0m \e[31m$1\e[0m"
}


function display_usage
{
    echo "Available commands:"
    echo -e "   go     \t Go to www.sillybytes.net"
    echo -e "   build  \t Rebuild Silly Bytes"
    echo -e "   watch  \t Run development server"
    echo -e "   deploy \t Deploy"
}

function isSillyDir
{
    repo_path=$(git rev-parse --show-toplevel 2> /dev/null)
    repo_path=${repo_path##*/}
    if [[ "$repo_path" == "sillybytes" ]]; then
        return 0
    else
        return 1
    fi
}

function build
{
    display_info "Rebuilding..."
    stack exec site rebuild
}

function watch
{
    display_info "Watching..."
    xdg-open "http://localhost:8000"
    stack exec site watch
}

function deploy
{
    if ! isSillyDir; then
        display_error "You're not currently in the Silly Bytes repo"
    else
        display_info "Generating..."
        stack exec site rebuild
        if [ $? -ne 0 ]; then
            display_error "The site couldn't be generated"
            exit 1
        fi

        if [ ! -d "_site" ]; then
            display_error "Generated site _site does not exist"
            exit 1
        fi

        cp -rf _site/* ../alx741.github.io/
        cd ../alx741.github.io
        display_info "Deploying..."
        git add .
        git commit -m "Deploy"
        git push origin master
        display_success "Deployed!"
    fi
}


banner
case "$1" in
    'go')
        xdg-open "http://www.sillybytes.net"
        ;;
    'build'|'generate'|'rebuild')
        build
        ;;
    'watch')
        watch
        ;;
    'deploy')
        deploy
        ;;
    *)
        display_usage
        ;;
esac
