#!/bin/sh

SB_PATH=$HOME/lab/sillybytes
GH_PAGE=$SB_PATH/sillybytes.github.io
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
    echo -e "   new    \t Generate boilerplate for new post"
    echo -e "   build  \t Build current post"
    echo -e "   clean  \t Clean current post"
    echo -e "   deploy \t Deploy current post"
}

function test_premises
{
    if [[ ! -f "post.md" ]]; then
        display_error "\"post.md\" file not found"
        exit 1
    fi
}

function clean
{
    rm -f post.html
}

function build
{
    test_premises

    clean
    sed -n '1!p' post.md | pandoc -o post.html
}

function new
{
    echo "Post name?"
    echo -n "$PROMPT"
    read post_name_raw

    if [[ "$post_name_raw" == "" ]]; then
        display_info "Nothing to do"
        exit 0
    fi

    post_name=$(echo "$post_name_raw" | sed 's/ /_/g')

    if [[ -d "$SB_PATH/$post_name" ]]; then
        echo
        display_warning "Post \"$post_name_raw\" already exists"
        exit 2
    fi

    cd "$SB_PATH"
    mkdir "$post_name"
    cd "$post_name"
    post_name_capitalized=$(echo "$post_name_raw" | sed 's/.*/\u&/')
    echo -e "# $post_name_capitalized\n\n" > post.md
}


function deploy
{
    test_premises

    post_title=$(head -n 1 post.md | sed 's/# //')
    display_info "Building \"$post_title\""
    build
    display_info "Deploying..."

    echo
    url_raw=$(python "$SCRIPT_DIR/deploy.py" "$post_title" post.html)

    if [[ "$?" != 0 ]]; then
        echo
        display_error "Deploy script is complaning"
        exit 1
    fi

    url=$(echo "$url_raw" | sed 's/Live: //')
    display_success "Deployed!"
    xdg-open "$url" > /dev/null
}


banner
case "$1" in
    'go')
        xdg-open "http://www.sillybytes.net"
        ;;
    'build'|'generate')
        build
        ;;
    'new')
        new
        ;;
    'clean')
        clean
        ;;
    'deploy')
        deploy
        ;;
    *)
        display_usage
        ;;
esac
